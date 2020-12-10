//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            self.touchPoint = touch.location(in: self)
            
            let tapNum: UInt = UInt(touch.tapCount)
            
            if 1 < tapNum {
                
                // 手裏剣を投げる
                self.playerNode.shoot() { [self] angle in
                    let wepon: SKSpriteNode = SKSpriteNode(imageNamed: "wepon")
                    wepon.name = kWeponName
                    wepon.physicsBody = SKPhysicsBody(circleOfRadius: wepon.size.width / 2)
                    
                    // 重力適用なし
                    wepon.physicsBody!.affectedByGravity = false
                    
                    self.baseNode.addChild(wepon)
                    
                    
                    wepon.position = self.playerNode.position
                    wepon.physicsBody!.categoryBitMask = UInt32(weponCategory)
                    wepon.physicsBody!.collisionBitMask = UInt32(enemyCategory)
                    wepon.physicsBody!.contactTestBitMask = UInt32(enemyCategory)
                    wepon.zRotation = angle
                    
                    //手裏剣を回転させる
                    let impulse: CGFloat = 5.5
                    //手裏剣の飛ぶ速さ
                    let x: CGFloat = sin(angle) * impulse
                    let y: CGFloat = cos(angle) * impulse
                    
                    wepon.physicsBody!.applyImpulse(CGVector(dx: -x,
                                                             dy: y))
                    
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if self.playerNode.isGetDamage == false {
                //タッチダウンした位置からの)距離を求め、それを速度とする
                let x: CDouble = CDouble(abs(self.touchPoint.x - location.x))
                let y: CDouble = CDouble(abs(self.touchPoint.y - location.y))
               
                var velocity: CGFloat = CGFloat(sqrt((x * x) + ( y * y)) * 2)
                
                if velocity < 30.0 {
                    velocity = 30.0
                }
                else if velocity > 100 {
                    velocity = 100
                }
                
                //タッチダウンした位置からプレイヤーの進行方向を求める
                let angle: CGFloat = CGFloat(-(atan2f(Float(location.x - self.touchPoint.x),
                                                      Float(location.y - self.touchPoint.y))))
                
//                let date = Date()
//                let calendar = Calendar.current
//             //   let hour = calendar.component(.hour, from: date)
//                let second = calendar.component(.second, from: date)
//                let minute = calendar.component(.minute, from: date)
//
                
            //    print("SET ANGLEEEE \(minute):\(second)")

                //プレイヤーキャラにアングルと速度を設定
                self.playerNode.setAngle(angle,
                                         Velocity: velocity)
            }
        }
    }
    
    //タッチアップ
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.playerNode.stop()
    }
    
    
    
}
