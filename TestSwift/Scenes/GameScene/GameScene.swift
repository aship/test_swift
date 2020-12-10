//
//  GameScene.swift
//  ShrimpSwim
//
//  Created by 村田 知常 on 2015/12/28.
//  Copyright (c) 2015年 shoeisha. All rights reserved.
//

import SpriteKit

//ゲームオーバーフラグ
var gameoverFlg = false

//ポイント
var count:NSInteger = 0

//ラベル
let gameoverLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
let pointLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")

// オブジェクト
var ball = SKSpriteNode(imageNamed:"ball")                     //ボール
var armRight = SKSpriteNode(imageNamed:"rightarm")             //右側アーム
var armLeft = SKSpriteNode(imageNamed:"leftarm")               //左側アーム
var back = SKSpriteNode(imageNamed:"back")                     //背景
var wallLeft = SKSpriteNode(imageNamed:"wallleft")             //左側の壁
var wallRight = SKSpriteNode(imageNamed:"wallright")           //右側の壁
var triangleLeft = SKSpriteNode(imageNamed:"triangleleft")     //左側の三角形の障害物
var triangleRight = SKSpriteNode(imageNamed:"triangleright")   //右側の三角形の障害物
var monster1 = SKSpriteNode(imageNamed:"monster1a")            //モンスター1
var monster2 = SKSpriteNode(imageNamed:"monster2a")            //モンスター2
var monster3 = SKSpriteNode(imageNamed:"monster3a")            //モンスター3
let playSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)    //効果音

class GameScene: SKScene,SKPhysicsContactDelegate {
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.0,
                                   y: 0.0)
    }

    
    override func didMove(to view: SKView) {
        //背景
        back.position = CGPoint(x:0,y:0)
        back.anchorPoint = CGPoint(x:0,y:0)
        self.addChild(back)
        self.size = CGSize(width: 320, height: 568)
        
        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0,dy:-4.0)
        self.physicsWorld.contactDelegate = self
        
        //ボールを作成
        makeBall()
        
        //壁左半分
        wallLeft.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"wallleft.png"), size: wallLeft.size)
        wallLeft.physicsBody?.restitution = 0.1
        wallLeft.physicsBody?.isDynamic = false
        wallLeft.physicsBody?.contactTestBitMask = 1
        wallLeft.position = CGPoint(x:80,y:284)
        self.addChild(wallLeft)
        
        //壁右半分
        wallRight.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"wallright.png"), size: wallRight.size)
        wallRight.physicsBody?.restitution = 0.1
        wallRight.physicsBody?.isDynamic = false
        wallRight.physicsBody?.contactTestBitMask = 1
        wallRight.position = CGPoint(x:240,y:284)
        self.addChild(wallRight)
        
        //アーム右
        armRight.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"rightarm.png"), size: armRight.size)
        armRight.physicsBody?.restitution = 1.2
        armRight.physicsBody?.isDynamic = false
        armRight.physicsBody?.contactTestBitMask = 1
        armRight.position = CGPoint(x:220,y:70)
        self.addChild(armRight)
        
        //アーム左
        armLeft.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"leftarm.png"), size: armLeft.size)
        armLeft.physicsBody?.restitution = 1.5
        armLeft.physicsBody?.isDynamic = false
        armLeft.physicsBody?.contactTestBitMask = 1
        armLeft.position = CGPoint(x:100,y:70)
        self.addChild(armLeft)
        
        //敵1（キノコ）
        monster1.name = "monster1"
        monster1.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"monster1a.png"), size: monster1.size)
        monster1.physicsBody?.restitution = 1.3
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.contactTestBitMask = 1
        monster1.position = CGPoint(x:140,y:410)
        self.addChild(monster1)
        
        //拡大縮小アニメーション
        let scaleA = SKAction.scale(to: 0.5, duration: 0.5)
        let scaleB = SKAction.scale(to: 1.0, duration: 1.5)
        let scaleSequence = SKAction.sequence([scaleA,scaleB])
        let scalerepeatAction =  SKAction.repeatForever(scaleSequence)
        monster1.run(scalerepeatAction)
        
        //敵1のパラパラアニメーション
        let parapraAction1 = SKAction.animate(with: [SKTexture(imageNamed: "monster1a.png"),SKTexture(imageNamed: "monster1b.png")], timePerFrame: 0.5)
        let paraparaRepeatAction1 =  SKAction.repeatForever(parapraAction1)
        monster1.run(paraparaRepeatAction1)
        
        //敵2（ドラゴン）
        monster2.name = "monster2"
        monster2.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"monster2a.png"),
                                             size: monster1.size)
        monster2.physicsBody?.restitution = 1.3
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.contactTestBitMask = 1
        monster2.position = CGPoint(x:100,y:300)
        self.addChild(monster2)
        
        //敵2の移動アニメーション
        let moveA = SKAction.move(to: CGPoint(x: 100,
                                              y: 300),
                                  duration: 1)
        let moveB = SKAction.move(to: CGPoint(x: 200,
                                              y: 300),
                                  duration: 1)
        let moveSequence = SKAction.sequence([moveA,moveB])
        let moveRepeatAction =  SKAction.repeatForever(moveSequence)
        monster2.run(moveRepeatAction)
        
        //敵2のパラパラアニメーション
        let parapraAction2 = SKAction.animate(with: [SKTexture(imageNamed: "monster2a.png"),
                                                     SKTexture(imageNamed: "monster2b.png")],
                                              timePerFrame: 0.5)
        let paraparaRepeatAction2 =  SKAction.repeatForever(parapraAction2)
        monster2.run(paraparaRepeatAction2)
        
        
        //敵3（スライム）
        monster3.name = "monster3"
        monster3.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"monster2a.png"),
                                             size: monster3.size)
        monster3.physicsBody?.restitution = 1.3
        monster3.physicsBody?.isDynamic = false
        monster3.physicsBody?.contactTestBitMask = 1
        monster3.position = CGPoint(x:150,y:200)
        self.addChild(monster3)
        
        //敵3の回転アニメーション
        let rotateAction = SKAction.rotate(byAngle: CGFloat(360 * Double.pi / 180),
                                           duration: 3)
        let rotateRepeatAction = SKAction.repeatForever(rotateAction)
        SKAction.repeat(rotateRepeatAction, count: 1000)
        monster3.run(rotateRepeatAction)
        
        //敵3のパラパラアニメーション
        let parapraAction3 = SKAction.animate(with: [SKTexture(imageNamed: "monster3a.png"),
                                                     SKTexture(imageNamed: "monster3b.png")],
                                              timePerFrame: 0.5)
        let paraparaRepeatAction3 =  SKAction.repeatForever(parapraAction3)
        monster3.run(paraparaRepeatAction3)
        
        
        
        //三角の壁左
        triangleLeft.name = "lefttriangle"
        triangleLeft.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"triangleleft.png"),
                                                 size: triangleLeft.size)
        triangleLeft.physicsBody?.restitution = 0.5
        triangleLeft.physicsBody?.isDynamic = false
        triangleLeft.position = CGPoint(x:70,y:150)
        self.addChild(triangleLeft)
        
        //三角の壁右
        triangleRight.name = "rihgttriangle"
        triangleRight.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed:"triangleright.png"),
                                                  size: triangleRight.size)
        triangleRight.physicsBody?.restitution = 0.5
        triangleRight.physicsBody?.isDynamic = false
        triangleRight.position = CGPoint(x:250,y:150)
        self.addChild(triangleRight)
        
        
        //得点ラベル
        pointLabel.text = "0点"
        pointLabel.fontSize = 25
        pointLabel.fontColor = UIColor(red:1 ,
                                       green: 1,
                                       blue: 1,
                                       alpha: 1)
        pointLabel.position = CGPoint(x: self.frame.midX,
                                      y: self.frame.midY)
        self.addChild(pointLabel)
        pointLabel.position = CGPoint(x:160, y:497)
    }
    
    //ボール（勇者）を作成
    func makeBall() {
        // ボールのスプライト
        _ = SKSpriteNode(imageNamed: "ball")
        
        // ボールのphysicsBodyの設定
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        ball.physicsBody?.contactTestBitMask = 1
        
        //ボールを配置
        ball.position = CGPoint(x:165,y:500)
        self.addChild(ball)
    }
}
