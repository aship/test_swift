//
//  GameSceneOtherCar.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    // 敵車のランダム作成
    func addOtherCar() {
        if _gameOver {
            return
        }
        
        if _accelete > 400 {
            //    print("ENEMYYYY")
            
            let road: SKNode = self.childNode(withName: kRoadName)!
            
            // プレイヤーカーを検索
            let reacingCar: SKSpriteNode = ((road.childNode(withName: kPlayerCarName) as? SKSpriteNode)!)
            
            
            let car: SKSpriteNode = SKSpriteNode(imageNamed: "OtherCar.png")
            
            //速度をランダムに作成してuserDataに保存する
            //     car.userData = Int(skRand(low: 200, high: 400))
            let speedX = Int(arc4random_uniform(20)) - 10
            let speedY = Int(arc4random_uniform(200)) + 200
            
            car.userData = NSMutableDictionary()
            car.userData?.setValue(speedX, forKey: "speedX")
            car.userData?.setValue(speedY, forKey: "speedY")
            
            //横位置をランダム、プレイヤーカーの１画面分上に配置する
            //    car.position = CGPoint(x: skRand(low: 40, high: 240)-140,
            //                         y: reacingCar.position.y + self.size.height)
            
            let positionX = CGFloat(Int(arc4random_uniform(200)) - 100)
            let positionY = reacingCar.position.y + screenHeight
            
            car.position = CGPoint(x: positionX,
                                   y: positionY)
            
            
            car.name = kOtherCarName
            
            car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
            car.physicsBody!.affectedByGravity = false
            //重力適用なし
            //接触設定
            //カテゴリー（その他の車）
            car.physicsBody!.categoryBitMask = UInt32(otherCarCategory)
            //接触できるオブジェクト
            car.physicsBody!.collisionBitMask = UInt32(playerCarCategory|otherCarCategory|wallCategory)
            //ヒットテストするオブジェクト
            car.physicsBody!.contactTestBitMask = UInt32(playerCarCategory)
            
            road.addChild(car)
        }
    }
    
    
    func skRand(low: CGFloat, high: CGFloat) -> CGFloat {
        let res: CGFloat = skRandf() * ((high - low) + low);
        
        return res;
    }
    
    func skRandf() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(RAND_MAX);
    }
}
