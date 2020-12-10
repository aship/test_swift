//
//  GameScene.swift
//  ArrowShooter
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let kRoadName = "Road"
    let kWallName = "Wall"                //壁（ガードレール）
    let kPlayerCarName = "PlayerCar"        //プレイヤーカー
    let kOtherCarName = "OtherCar"            //その他の車
    let kRoadViewName = "RoadView"            //道路（表示スプライト）
    let kDistLabelName = "DistLabel"        //距離
    let kSpeedLabelName = "Speed"
    
    //カテゴリビットマスク
    let wallCategory        =  0x1 << 0;    //壁（ガードレール）
    let playerCarCategory    =  0x1 << 1;    //プレイヤーカー
    let otherCarCategory    =  0x1 << 2;    //その他の車
    
    var gameDelegate: Int = 0
    var distance: CGFloat = 0.0
    
    
    var _carStartPt = CGPoint(x: 0, y: 0)
    var _gameOver = false
    var _acceleON = false
    var _touchPoint = CGPoint(x: 0, y: 0)
    var _accelete: CGFloat = 0.0
    var _particleFire: SKEmitterNode?
    var _particleSpark: SKEmitterNode?
    var _particleSmoke: SKEmitterNode?
    
    // 縦に何枚の画像をつなげるか
    let numberOfRoad = 3
    let numberOfWall = 3
    
    // プレイヤーの初期位置
    let playerOffsetY = -160
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        //接触デリゲート
        self.physicsWorld.contactDelegate = self
        
        //=============================================
        //道路
        let roadNode: SKNode = SKNode()
        roadNode.name = kRoadName
        self.addChild(roadNode)
        
        print("roadNode.position  \(roadNode.position)")
        //  print("roadNode.size  \(roadNode.fra)")
        
        // road
        for i in 0 ..< self.numberOfRoad {
            let road = SKSpriteNode(imageNamed: "Road.png")
            road.name = kRoadViewName
            road.position = CGPoint(x: 0,
                                    y: Int(road.size.height) * i)
            roadNode.addChild(road)
        }
        
        // left wall
        for i in 0 ..< self.numberOfWall {
            let wall = SKSpriteNode(imageNamed: "Wall_L.png")
            wall.name = kWallName
            
            let positionX: CGFloat = -1 * screenWidth / 2 + wall.size.width / 2
            let positionY: CGFloat = CGFloat(Int(wall.size.height) * i)
            
            wall.position = CGPoint(x: positionX,
                                    y: positionY)
            wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wall.size.width,
                                                                 height: wall.size.height))
            wall.physicsBody!.affectedByGravity = false
            wall.physicsBody!.categoryBitMask = UInt32(wallCategory)
            wall.physicsBody!.collisionBitMask = 0
            roadNode.addChild(wall)
        }
        
        // right wall
        for i in 0 ..< self.numberOfWall {
            let wall = SKSpriteNode(imageNamed: "Wall_R.png")
            wall.name = kWallName
            
            wall.position = CGPoint(x: screenWidth / 2 - wall.size.width / 2,
                                    y: wall.size.height * CGFloat(i))
            
            wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wall.size.width,
                                                                 height: wall.size.height))
            wall.physicsBody!.affectedByGravity = false
            //重力適用なし
            wall.physicsBody!.categoryBitMask = UInt32(wallCategory)
            wall.physicsBody!.collisionBitMask = 0
            roadNode.addChild(wall)
        }
        
        
        //プレイヤーカー
        let playerCar: SKSpriteNode = SKSpriteNode(imageNamed: "PlayerCar.png")
        playerCar.name = kPlayerCarName
        
        roadNode.addChild(playerCar)
        
        playerCar.position = CGPoint(x: 0,
                                     y: playerOffsetY)
        _carStartPt = playerCar.position
        
        //初期位置を記録
        playerCar.physicsBody = SKPhysicsBody(rectangleOf: playerCar.size)
        // 重力適用なし
        playerCar.physicsBody!.affectedByGravity = false
        // 衝突による角度変更なし
        playerCar.physicsBody!.allowsRotation = false
        
        //接触設定
        //カテゴリー（プレイヤーカー）
        playerCar.physicsBody!.categoryBitMask = UInt32(playerCarCategory)
        //接触できるオブジェクト（壁／その他の車）
        playerCar.physicsBody!.collisionBitMask = UInt32(wallCategory|otherCarCategory)
        //ヒットテストするオブジェクト（壁／その他の車）
        playerCar.physicsBody!.contactTestBitMask = UInt32(wallCategory|otherCarCategory)
        //=============================================
        
        // 車を一定間隔でランダムに作る
        let makeMeteors: SKAction = SKAction.sequence([SKAction.run(self.addOtherCar),
                                                       SKAction.wait(forDuration: 1.5,
                                                                     withRange: 1.0)])
        self.run(SKAction.repeatForever(makeMeteors))
        
        
        //=============================================
        //走行距離
        let scoreTitleNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreTitleNode.fontSize = 20
        scoreTitleNode.text = "Distance"
        scoreTitleNode.position = CGPoint(x: -50,
                                          y: 300)
        self.addChild(scoreTitleNode)
        
        let scoreNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreNode.name = kDistLabelName
        scoreNode.fontSize = 20
        scoreNode.position = CGPoint(x: 50,
                                     y: 300)
        self.addChild(scoreNode)
        
        // スピード
        let speedTitleNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        speedTitleNode.fontSize = 20
        speedTitleNode.text = "Speed"
        speedTitleNode.position = CGPoint(x: -50,
                                          y: 260)
        self.addChild(speedTitleNode)
        
        let speedNode: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
        speedNode.name = kSpeedLabelName
        speedNode.fontSize = 20
        speedNode.position = CGPoint(x: 50,
                                     y: 260)
        self.addChild(speedNode)
    }
}
