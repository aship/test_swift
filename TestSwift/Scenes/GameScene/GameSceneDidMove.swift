//
//  GameSceneDidVmo.swift
//  ArrowShooter
//
//  Created by aship on 2020/11/09.
//  Copyright © 2020 STUDIO SHIN. All rights reserved.
//

import SpriteKit

extension GameScene {
    override func didMove(to view: SKView) {
        // BGM再生（音楽：魔王魂）
        let filePath: String? = Bundle.main.path(forResource: "bgm_battle",
                                                 ofType: "m4a")
        if let path = filePath {
            self.soundPlayer.setBGMSound(path)
        }
        
        let mapNumber = 0
        let stgNumber = 0
        
        // マップデータをロード
        self.nodeDictionary = self.load(map: mapNumber,
                                        stg: stgNumber)
        self.mapNumber = mapNumber
        self.stgNumber = stgNumber
        
        //接触デリゲート
        self.physicsWorld.contactDelegate = self
        
        
        //ゲームのセットアップ
        self.gameSetup()
        
        self.gameState = .gameReady    //ステータスをゲーム開始前にする
        // self.gameState = .gameEdit
        self.setupGameReady()
    }
    
    private func setupGameReady() {
        self.physicsWorld.speed = 0.0
        //射撃コントローラ初期化
        self.cntBowNode.xScale = 1.0
        self.cntBowNode.yScale = 1.0
        self.cntArrowNode.position = CGPoint(x: 0, y: 0)
        self.cntBackNode.isHidden = true
        //パラメータ初期化
        self.shootOK = true            //射撃可能フラグ
        self.moving = false            //移動中フラグ
        self.drawingBow = false        //弓を引いているフラグ
        self.takeExp = 0            //獲得経験値
        self.takeMoney = 0            //獲得コイン
        self.shotArrows = 0            //撃った矢の数
        self.hitArrows = 0            //当たった矢の数
        
        // 持っている矢の数
        self.haveArrows = 9100
        
        self.battleOnBoss = false    //ボス戦フラグ
        
        
        let action: SKAction = SKAction.run({() -> Void in
            self.gameState = .gamePlaying
            self.physicsWorld.speed = 1.0
            //ゲームスタート通知
            self.gameDelegate?.gameSceneNotificationGameStart()
            //プレイヤー移動開始
            self.moving = true    //移動ON
            self.playerNode.startMoveTextureAnimation()
            //射撃コントローラを表示
            self.cntBackNode.isHidden = false
        })
        
        let actionArray = [SKAction.wait(forDuration: 1.0),
                                       action]
        //ゲーム中に遅延変更
        self.run(SKAction.sequence(actionArray))
    }
    
    // 読み込み
    func load(map: Int,
              stg: Int)-> NSDictionary! {
        let mapName = "map\(map)-\(stg)"
     //   self.mapNameLabel.text = mapName
        var dict: NSDictionary!
        
     //   if self.isDebug {
//        if false {
//            //Documentsフォルダからロード＜デバッグ用＞
//            let ary = NSSearchPathForDirectoriesInDomains(.documentDirectory,
//                                                          .userDomainMask, true)
//            let path = ary[0]
//            let filePath = path + "/" + mapName + ".plist"
//            dict = NSDictionary(contentsOfFile: filePath)
//        }
//        else{
            //Bundleからロード
            let path = Bundle.main.path(forResource: mapName,
                                        ofType: "plist")!
            dict = NSDictionary(contentsOfFile: path)
      //  }
        
        return dict
    }
    
    func gameSetup() {
        //ノードを削除
        var nodes = self.baseNode.children
        for node in nodes {
            node.removeFromParent()
        }
        
        nodes = self.children
        for node in nodes {
            node.removeFromParent()
        }
        
        //アクションを削除
        self.removeAllActions()
        
        /*--------------------------
         MARK: ゲーム背景画面表示ノード
         --------------------------*/
        // 背景
        let back_name = "map_back\(self.mapNumber)"
        let backNode = SKSpriteNode(imageNamed: back_name)
        backNode.name = NodeName.backGround.rawValue
        backNode.setScale(1.2)
        backNode.position = CGPoint(x: 0,
                                    y: 60)
        self.addChild(backNode)
        
        
        // baseNodeをシーンの子ノードとする
        self.addChild(self.baseNode)
        
        self.baseNode.position = CGPoint(x: 0,
                                         y: 0)
        let wCount = 5    //画面数
        self.screenSize = CGSize(width: screenWidth * CGFloat(wCount),
                                 height: screenHeight)
        
        //　baseNodeの子コードとして背景ノードを配置する
        for i in 0 ..< Int(wCount) {
            // 中景
            let middle_name = "map_middle\(self.mapNumber)"
            
            let middle = SKSpriteNode(imageNamed: middle_name)
            middle.name = NodeName.middleGround.rawValue
            self.baseNode.addChild(middle)
            middle.zPosition = 2
            
            let middle_w = middle.size.width * CGFloat(i)
            middle.position = CGPoint(x: -1 * screenWidth / 2 + middle_w,
                                      y: 0)
            
            // 地面
            let ground_name = "map_ground\(self.mapNumber)"
            
            let    ground = SKSpriteNode(imageNamed: ground_name)
            ground.name = NodeName.ground.rawValue
            self.baseNode.addChild(ground)
            ground.zPosition = 3
            
            let ground_w = ground.size.width * CGFloat(i)
            ground.position = CGPoint(x: -1 * screenWidth / 2 + ground_w,
                                      y: 0)
        }
        
        /*--------------------------
         MARK: 地面あたり
         --------------------------*/
        // 地面あたりのノードを作成
        let groundFrameNode = SKNode()
        groundFrameNode.name = NodeName.frame_ground.rawValue
        self.baseNode.addChild(groundFrameNode)
        
        //変更可能なパスを作成
        let path = CGMutablePath()
        
        // パスの開始位置設定
        path.move(to: CGPoint(x: -1 * screenWidth / 2,
                              y: 0))
        
        
        
        // パスにポイントを追加
        // wCount 画面数
        let pointX = screenWidth * CGFloat(wCount)
        path.addLine(to: CGPoint(x: pointX,
                                 y: 0))
        
        // パスを閉じる
        path.closeSubpath()
        
        //物理設定・パスからあたりを作成する
        groundFrameNode.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
        groundFrameNode.physicsBody!.categoryBitMask = NodeName.frame_ground.category()
        
        /*--------------------------
         MARK: プレイヤー
         --------------------------*/
        self.playerNode = CharactorNode(atlas: SKTextureAtlas(named: "player"))
        playerNode.anchorPoint = CGPoint(x: 0.5,
                                         y: 0.0)
        playerNode.name = NodeName.player.rawValue
        playerNode.position = CGPoint(x: playerInitX,
                                      y: 50)
        playerNode.zPosition = NodeName.player.zPosition()
        playerNode.velocity = 60
        playerNode.hp = 1                            // HP
        playerNode.attack = 10                        //攻撃力
        self.baseNode.addChild(playerNode)
        
        //物理設定
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.height/2,
                                               center: CGPoint(x: 0, y: playerNode.size.height/2))
        playerNode.physicsBody!.categoryBitMask = NodeName.player.category()
        playerNode.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.obstacle.category()|NodeName.item.category()
        playerNode.physicsBody!.contactTestBitMask = NodeName.item.category()
        playerNode.physicsBody!.allowsRotation = false
        
        // test 重力をオフにすると動かなくなった
        //   playerNode.physicsBody?.isDynamic = false
        
        /*--------------------------
         MARK: 配置
         --------------------------*/
        self.nodeSetup(self.nodeDictionary)
        
        
        /*--------------------------
         MARK: 射撃コントローラノード
         --------------------------*/
        // コントローラの土台
        self.addChild(self.cntBackNode)
        self.cntBackNode.position = CGPoint(x: 0,
                                            y: -180)
        self.cntBackNode.zPosition = 70
        
        // 回転ノード
        if self.cntRotNode.parent == nil {
            self.cntBackNode.addChild(self.cntRotNode)
            self.cntRotNode.position = CGPoint(x: 40.0, y: 40.0)
            self.cntRotNode.zPosition = 71
        }
        
        self.cntRotNode.zRotation = -CGFloat(Double.pi / 2)
        
        // 矢
        if self.cntArrowNode.parent == nil {
            self.cntRotNode.addChild(self.cntArrowNode)
            self.cntArrowNode.isHidden = false
            self.cntArrowNode.zPosition = 72
        }
        
        // 弓
        if self.cntBowNode.parent == nil {
            self.cntRotNode.addChild(self.cntBowNode)
            self.cntBowNode.anchorPoint = CGPoint(x: 0.5, y: 0.8)
            self.cntBowNode.position = CGPoint(x: 0, y: 30)
            self.cntBowNode.zPosition = 73
            
            // 装備している弓の画像変更
            let path = Bundle.main.path(forResource: "ItemList", ofType: "plist")
            let itemList = NSArray(contentsOfFile: path!)
            let userDef = UserDefaults.standard
            let equBow = userDef.integer(forKey: "equBow")
            if equBow == -1 {
                self.cntBowNode.texture = SKTexture(image: UIImage(named: "cnt_bow")!)
            } else {
                let itemDic = itemList![equBow] as! NSDictionary
                let imageName = itemDic["imageName"] as! String
                self.cntBowNode.texture = SKTexture(image: UIImage(named: imageName)!)
            }
        }
        
        /*--------------------------
         MARK: 時間のカウント
         --------------------------*/
        //ゲーム制限時間初期化
        self.countdownTime = self.gameLimitTime
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        
        let runAction = SKAction.run({ () -> Void in
            if self.gameState == .gamePlaying && self.pause == false {
                let sec = Int(self.countdownTime)
                if sec <= 0 {
                    //ゲームオーバー！！
                    self.gameState = .gameLose    //ゲームステータス変更
                } else {
                    //時間を減算する
                    self.countdownTime -= 1.0
                }
            }
        })
        
        let actions = [waitAction,
                       runAction]
        
        let timeCountAction = SKAction.sequence(actions)
        
        //アクションを無限リピート実行する
        self.run(SKAction.repeatForever(timeCountAction), withKey: "timeCountAction")
        
        /*--------------------------
         MARK: 画面を覆うマスクノードを配置する
         --------------------------*/
        let mask = SKSpriteNode(color: UIColor.black,
                                size: self.size)
        mask.name = "maskNode"
        self.addChild(mask)
        mask.zPosition = 200
        mask.position = CGPoint(x: mask.size.width/2,
                                y: mask.size.height/2)
        // しばらく待機後、フェードで消す
        mask.run(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                    SKAction.fadeAlpha(to: 0.0, duration: 0.5),
                                    SKAction.removeFromParent()]))
    }
}
