//
//  GameScene.swift
//  ArrowShooter
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let kMissileName   = "Missile"        //ミサイル
    let kSpaceshipName  = "Spaceship"    //宇宙船
    let  kMeteorName   = "Meteor"        //隕石
    let  kEarthName    = "Earth"        //地球
    let kBackName  = "Back"            //背景
    let  kScoreName    = "Score"        //スコア
    let   kFallenName  = "Fallen"        //落下数
    let  kLevelName   = "Level"        //レベル
    
    //カテゴリビットマスク
    var missileCategory    =  0x1 << 0;    //ミサイル
    var meteorCategory    =  0x1 << 1;    //隕石
    var earthCategory        =  0x1 << 2;    //地球
    var spaceshipCategory    =  0x1 << 3;    //宇宙船
    
    var score = 0            //スコア
    var fallenNumber = 0    //隕石衝突数
    
    var _isRotating = false
    
    var _textureMissile: SKTexture?
    var _textureMeteor: SKTexture?
    
    var _gameOver = false
    
    var _particleFire: SKEmitterNode?
    var _particleSpark: SKEmitterNode?
    var _particleBom: SKEmitterNode?
    var _particleSmoke: SKEmitterNode?
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }

    override func didMove(to view: SKView) {
        //接触デリゲート
        self.physicsWorld.contactDelegate = self
        
        //背景
        let space: SKSpriteNode = SKSpriteNode(imageNamed: "GameBack.png")
        space.position = CGPoint(x: 0,
                                 y: 0)
        space.name = kBackName
        self.addChild(space)
        
        // 地球
        let earth: SKSpriteNode = SKSpriteNode(imageNamed: "Earth.png")
        earth.position = CGPoint(x: 0,
                                 y: earth.size.height / 2 - screenHeight / 2)
        earth.name = kEarthName
        earth.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: earth.size.width,
                                                              height: earth.size.height / 2))
        earth.physicsBody!.isDynamic = false
        earth.physicsBody!.categoryBitMask = UInt32(earthCategory)
        //接触できるオブジェクト（なし）
        earth.physicsBody!.collisionBitMask = 0
        self.addChild(earth)
        
        // 宇宙船
        let spaceship: SKSpriteNode = SKSpriteNode(imageNamed: "Spaceship.png")
        spaceship.position = CGPoint(x: 0,
                                     y: spaceship.size.height - screenHeight / 2)
        spaceship.name = kSpaceshipName
        spaceship.physicsBody = SKPhysicsBody(circleOfRadius: spaceship.size.width / 2)
        spaceship.physicsBody!.isDynamic = false
        //接触設定
        spaceship.physicsBody!.categoryBitMask = UInt32(spaceshipCategory)
        spaceship.physicsBody!.collisionBitMask = 0
        self.addChild(spaceship)
        
        //スコア
        
        //タイトル
        let scoreTitleNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreTitleNode.fontSize = 20
        scoreTitleNode.text = "SCORE"
        self.addChild(scoreTitleNode)
        scoreTitleNode.position = CGPoint(x: -100,
                                          y: 280)
        
        let scoreNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreNode.name = kScoreName
        scoreNode.fontSize = 20
        scoreNode.position = CGPoint(x: -40,
                                     y: 280)
        self.addChild(scoreNode)
        
        // スコア
        self.score = 0
        self.setScore(0)
        
        // 重力を1/50にする
        self.physicsWorld.gravity = CGVector(dx: 0,
                                             dy: -(9.8 * 0.02))
        
        //ミサイルのテクスチャ
        _textureMissile = SKTexture(imageNamed: "Missile.png")
        //隕石のテクスチャ
        _textureMeteor = SKTexture(imageNamed: "Meteor.png")
        
        
        
        //隕石を一定間隔でランダムに作る
        let makeMeteors: SKAction = SKAction.sequence([SKAction.run(self.addMeteor),
                                                       SKAction.wait(forDuration: 1.8,
                                                                     withRange: 1.6)])
        self.run(SKAction.repeatForever(makeMeteors))
        
        //隕石落下数
        let fallenNumNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        fallenNumNode.name = kFallenName
        fallenNumNode.fontSize = 30
        fallenNumNode.position = CGPoint(x: 100,
                                         y: 280)
        self.addChild(fallenNumNode)
        
        self.fallenNumber = 3
        self.setFallenNumber(Int32(self.fallenNumber))
        
        /*
         
         //レベル
         SKLabelNode*    levelNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
         levelNode.name = kLevelName;
         levelNode.fontSize = 20;
         [self addChild:levelNode];
         self.level = 1;
         levelNode.position = CGPointMake(self.frame.size.width-(levelNode.frame.size.width/2)-20, self.frame.size.height-60);
         */
        
    }
    
    override func willMove(from view: SKView) {
    }
}
