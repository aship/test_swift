//
//  GameScene.swift
//  ArrowShooter
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var playerInitX: CGFloat = -120.0
    let soundPlayer: SoundPlayer = SoundPlayer()
    
    var gameDelegate: GameSceneDelegate!
    
    // MARK: ゲームステータス
    var _gameState: GameState!
    var gameState: GameState {
        //ゲッター
        get {
            return _gameState
        }
        //セッター
        set {
            self._gameState = newValue
            /*-------------------------------
             MARK: >ゲーム開始前
             -------------------------------*/
            if _gameState == .gameReady {

            }
            /*-------------------------------
             MARK: >ゲームプレイ中
             -------------------------------*/
            if _gameState == .gamePlaying {
                
            }
            /*-------------------------------
             MARK: >ゲームオーバー
             -------------------------------*/
            if _gameState == .gameLose {
                //射撃コントローラを親nodeから削除
                self.cntBackNode.removeFromParent()
                //すべてのサブノードのアクションを停止
                self.physicsWorld.speed = 0.0
                let children = self.baseNode.children
                for child in children {
                    child.isPaused = true
                }
                //マスク
                let mask = SKSpriteNode(color: UIColor.black, size: self.size)
                mask.name = "maskNode"
                self.addChild(mask)
                mask.zPosition = NodeName.player.zPosition() - 1
                mask.position = CGPoint(x: mask.size.width/2, y: mask.size.height/2)
                mask.alpha = 0
                mask.run(SKAction.fadeAlpha(to: 1.0, duration: 2.5))
                
                //GAME OVER 表示
                let signNode = SKSpriteNode(imageNamed: "GameOver")
                signNode.name = "titleSign"
                signNode.zPosition = 100
                self.addChild(signNode)
                signNode.position = CGPoint(x: screenWidth/2, y: screenHeight-140)
                //RESULTボタン
                let result = SKButtonSprite(imageNamed: "result")
                result.zPosition = 200
                self.addChild(result)
                result.position = CGPoint(x: screenWidth/2, y: screenHeight/2-70)
                result.handler = {()-> Void in
                    //マスクノードの優先アップ
                    mask.zPosition = 200
                    //ゲームオーバーの場合タイムは０
                    self.countdownTime = 0
                    //リザルト画面
                    self.gameDelegate!.gameSceneNotificationToResult()
                }
                
                //ボタンをフェードで表示する
                result.alpha = 0
                result.run(SKAction.sequence([SKAction.wait(forDuration: 4.0),
                                              SKAction.fadeAlpha(to: 1.0, duration: 0.2)]))
                
                //ゲームオーバー通知
                self.gameDelegate?.gameSceneNotificationGameOver()
            }
            /*-------------------------------
             MARK: >ゲームクリア
             -------------------------------*/
            if _gameState == .gameWin {
                //射撃コントローラを親nodeから削除
                self.cntBackNode.removeFromParent()
               
                //すべてのサブノードのアクションを停止
                self.physicsWorld.speed = 0.0
                let children = self.baseNode.children
                for child in children {
                    child.isPaused = true
                }
                
                //GAME CLEAR 表示
                let signNode = SKSpriteNode(imageNamed: "GameClear")
                signNode.name = "titleSign"
                signNode.zPosition = 100
                self.addChild(signNode)
                signNode.position = CGPoint(x: 0,
                                            y: 200)
                
                // RESULTボタン
                let result = SKButtonSprite(imageNamed: "result")
                result.zPosition = 100
                self.addChild(result)
                result.position = CGPoint(x: 0,
                                          y: 100)
                
                result.handler = {()-> Void in
                    //マスク
                    let mask = SKSpriteNode(color: UIColor.black,
                                            size: self.size)
                    mask.name = "maskNode"
                    self.addChild(mask)
                    mask.zPosition = 200
                    mask.position = CGPoint(x: mask.size.width / 2,
                                            y: mask.size.height / 2)
                    //リザルト画面
                    self.gameDelegate!.gameSceneNotificationToResult()
                }
                //ボタンをフェードで表示する
                result.alpha = 0
                result.run(SKAction.sequence([SKAction.wait(forDuration: 7.0),
                                              SKAction.fadeAlpha(to: 1.0, duration: 0.2)]))
                //ゲームクリア通知
                self.gameDelegate?.gameSceneNotificationGameClear()
            }
            /*-------------------------------
             MARK: >編集
             -------------------------------*/
            if _gameState == .gameEdit {
                
            }
        }
    }
    //MARK: ポーズ
    var _pause: Bool = false
    var pause: Bool {
        get {
            return	_pause
        }
        set{
            _pause = newValue
            if _pause {
                /*-----------------
                 ポーズ
                 -----------------*/
                self.physicsWorld.speed = 0.0
                let children = self.baseNode.children
                for child in children {
                    child.isPaused = _pause
                }
            }
            else{
                /*-----------------
                 ポーズ解除
                 -----------------*/
                self.physicsWorld.speed = 1.0
                let children = self.baseNode.children
                for child in children {
                    child.isPaused = _pause
                }
            }
        }
    }
    
    
    
    
    //---------------------------------
    //MARK: 射撃コントロール
    //---------------------------------
    let	cntBackNode = SKSpriteNode(color: UIColor.clear,
                                      size: CGSize(width: 320,
                                                   height: 200))
    let	cntRotNode = SKNode()
    let	cntBowNode = SKSpriteNode(imageNamed: "cnt_bow")
    let	cntArrowNode = SKSpriteNode(imageNamed: "cnt_arrow")
    
    //---------------------------------
    //MARK: 射撃パラメータ
    //---------------------------------
    var shootOK = true						//矢射撃可能フラグ
    var moving = false						//移動中フラグ
    var drawingBow = false					//弓を引いているフラグ
    var shootRadian = -CGFloat(Double.pi / 2)		//矢を射撃する初期角度（真上が0）
    var drawLength: CGFloat = 0.0			//弓を引いている距離
    var drawPower: CGFloat = 800.0			//弓を引く力
    
    //---------------------------------
    //MARK:マップデータ
    //---------------------------------
    var baseNode = SKNode()					//ゲームベースノード
    var screenSize: CGSize = CGSize.zero		//画面サイズ
    var mapNumber: Int = 0					//マップ番号
    var stgNumber: Int = 0					//ステージ番号
    
    //---------------------------------
    //MARK:プレイヤーデータ
    //---------------------------------
    var playerNode: CharactorNode!			//プレイヤーキャラ
    var moveTimer: Timer!					//移動タイマー
   
    //プレイヤーレベル
    var _playerLV: Int = 1
    var playerLV: Int {
        get{
            return _playerLV
        }
        set{
            _playerLV = newValue
            //バンドルからPLISTを読み込む
            let path = Bundle.main.path(forResource: "PlayerLV", ofType: "plist")
            let playerLvs = NSArray(contentsOfFile: path!)
            //攻撃力
            let paramDic = playerLvs![_playerLV-1] as! Dictionary<String, AnyObject>
            self.playerNode.attack = paramDic["attack"] as! CGFloat
            
            //装備武器による攻撃力の加算
            let userDef = UserDefaults.standard
            let equBow = userDef.integer(forKey: "equBow")
            if equBow != -1 {
                //アイテムリストを読み込む
                let path = Bundle.main.path(forResource: "ItemList", ofType: "plist")
                let itemList = NSArray(contentsOfFile: path!)
                let item = itemList![equBow] as! NSDictionary
                playerNode.attack += item["attack"] as! CGFloat
            }
        }
    }
    var battleOnBoss: Bool = false			//ボス戦中フラグ
    
    
    
    
    //---------------------------------
    //MARK:ゲーム情報／リザルトパラメータ
    //---------------------------------
    var _takeExp: Int = 0					//獲得経験値
    var takeExp: Int{
        get{
            return _takeExp
        }
        set{
            _takeExp = newValue
            //経験値獲得通知
            self.gameDelegate?.gameSceneNotificationTakeExp(_takeExp)
        }
    }
    var shotArrows: Int = 0					//射撃した矢
    var hitArrows: Int = 0					//命中した矢
    var _takeMoney: Int = 0					//獲得コイン
    var takeMoney: Int{
        get{
            return _takeMoney
        }
        set{
            _takeMoney = newValue
            //コイン獲得通知
            self.gameDelegate?.gameSceneNotificationTakeMoney(_takeMoney)
        }
    }
    var _haveArrows: Int = 0				//所持矢数
    var haveArrows: Int {
        
        get {
            return _haveArrows
        }
        set {
            _haveArrows = newValue
            //矢の数を通知
            self.gameDelegate?.gameSceneNotificationArrowCount(_haveArrows)
        }
    }
    
    
    
    var gameLimitTime: Float = 90.0			//ゲーム制限時間
    var _countdownTime: Float = 0.0
    var countdownTime: Float {				//ゲームの残り時間
        get{
            return _countdownTime
        }
        set{
            _countdownTime = newValue
            //時間通知
            self.gameDelegate?.gameSceneNotificationTimeCountDown(Int(_countdownTime))
        }
    }
    
    
    //---------------------------------
    //MARK: 配置用プロパティ＜デバッグ＞
    //---------------------------------
    var nodeDictionary: NSDictionary?		//配置データを保持する辞書
    var screenScrollRight: Bool = false		//画面 右スクロール
    var screenScrollLeft: Bool = false		//画面 左スクロール
    var putKind: Int = 0					//配置物の種類
    var putNumber: Int = 0					//配置物番号
    var putNode: SKSpriteNode!				//配置中のノード
    var editMode: Int = 0					//編集モード（0=配置  1=削除）
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
}
