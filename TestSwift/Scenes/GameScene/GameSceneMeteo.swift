//
//  GameSceneOtherCar.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    func addMeteor() {
        if _gameOver {
            return
        }
        
        let meteor: SKSpriteNode = SKSpriteNode(texture: _textureMeteor)
        
        let randX: CGFloat = CGFloat(arc4random_uniform(UInt32(screenWidth))) - screenWidth / 2
        
        meteor.position = CGPoint(x: randX,
                                  y: screenHeight / 2)
        meteor.name = kMeteorName
        
        //物理シミュレーション
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width/2)
        self.addChild(meteor)
        
        //接触設定
        meteor.physicsBody!.categoryBitMask = UInt32(meteorCategory)
        //カテゴリー（隕石）
        meteor.physicsBody!.contactTestBitMask = UInt32(spaceshipCategory|earthCategory)
        //ヒットテストするオブジェクト（宇宙船／ミサイル）
        meteor.physicsBody!.collisionBitMask = UInt32(spaceshipCategory|earthCategory)
        //接触できるオブジェクト（宇宙船／ミサイル）
        
        let randX2: CGFloat = CGFloat(arc4random_uniform(50)) - 25
        let randY2: CGFloat = CGFloat(arc4random_uniform(10) + 50)
        
        //下方向に回転させて発射
        meteor.physicsBody!.velocity = CGVector(dx: randX2,
                                                dy: -1 * randY2)
        meteor.physicsBody!.applyTorque(0.04)
        //回転
        
        // 隕石のパーティクル
        do {
            let fileURL = Bundle.main.url(forResource: "Spark", withExtension: "sks")!
            let fileData = try Data(contentsOf: fileURL)
            let fireSpark = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as! SKEmitterNode
            
            fireSpark.position = CGPoint(x: 0,
                                         y: 0)
            fireSpark.particleLifetime = 0.3
            fireSpark.particleBirthRate = 500
            fireSpark.emissionAngle = CGFloat(Double.pi / 2)
            fireSpark.emissionAngleRange = 0
            fireSpark.particlePositionRange = CGVector(dx: 10,
                                                       dy: 10)
            fireSpark.particleAlpha = 0.4
            fireSpark.particleAlphaRange = 0.0
            fireSpark.particleAlphaSpeed = -0.3
            
            //パーティクルを隕石に配置
            meteor.addChild(fireSpark)
            fireSpark.targetNode = self
        } catch {
            print("didn't work")
        }
    }
}
