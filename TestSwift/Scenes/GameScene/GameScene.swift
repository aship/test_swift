//
//  GameScene.swift
//  ShrimpSwim
//
//  Created by 村田 知常 on 2015/12/28.
//  Copyright (c) 2015年 shoeisha. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene,SKPhysicsContactDelegate {
    //NSUserDefaultsを生成
    let defaults = UserDefaults.standard
    
    // CMMotionManagerを格納する変数
    var motionManager: CMMotionManager!
    
    //背景のスプライト
    let bgSprite = SKSpriteNode(imageNamed:"background")
    
    //フレーム
    let frameSprite = SKSpriteNode(imageNamed:"frame")
    
    //スコアの背景スプライト
    var scoreFramesprite = SKSpriteNode(imageNamed: "score")
    
    //スコアのラベル
    let pointLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    let highScoreLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    
    //キャラクタのスプライト
    let charaSprite = SKSpriteNode(imageNamed:"up")
    var charaYpos:CGFloat = 0
    
    //キャラクタの設定用変数
    var charaYposition:CGFloat = 0      //キャラクタのy座標
    var charaXposition: Double = 0      //キャラクタのx座標
    var contactFlg = true          //ブロックとの当たり判定用
    
    //地面のスプライト
    var floorSprite = SKSpriteNode()
    
    //ブロック配置用ノード
    let blocksNode = SKNode()
    
    //ブロックスプライト
    let blockSprite = SKSpriteNode(imageNamed:"ground")
    
    //ゲームオーバー画像を表示するスプライト
    let gameoverSprite = SKSpriteNode(imageNamed:"gameover")
    var gameoverFlg = false
    
    //俳句画像を表示するスプライト
    let haikuSprite = SKSpriteNode(imageNamed:"paper20")
    
    //得点
    var point:Int = 0
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.0,
                                   y: 0.0)
    }

    override func didMove(to view: SKView) {
        self.view?.scene?.setScale(1.5)
        //スプライトを配置
        layoutObjects()
        
        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0.0, dy:-3.0)
        self.physicsWorld.contactDelegate = self
        
        //CMMotionManagerを生成
        motionManager = CMMotionManager()
        
        //加速度の値の取得の間隔を設定する
        motionManager.accelerometerUpdateInterval = 0.1 //0.1秒毎に取得
        
        //ハンドラを設定します
        let accelerometerHandler: CMAccelerometerHandler = {
            (data:CMAccelerometerData?, error: Error?) -> Void in
            
            //ログにx,y,zの加速度を表示する
            print("x:\(data!.acceleration.x)  y:\(data!.acceleration.y) z:\(data!.acceleration.z)")
            
            //キャラクタのx座標を設定（data.acceleration.xの値が小さすぎて座標には使えないので20をかける）
            self.charaXposition = data!.acceleration.x * 20
        }
        
        //取得開始して、上記で設定したハンドラを呼び出し、ログを表示する
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!,
                                                withHandler: accelerometerHandler)
    }
}
