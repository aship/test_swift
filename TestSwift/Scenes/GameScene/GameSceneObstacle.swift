//
//  GameSceneMake.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    // 障害物を作る
    func makeObstacle(_ itemNum: Int,
                      position: CGPoint)->SKSpriteNode! {
        var    obstacle: SKSpriteNode!
        switch itemNum {
        
        case 0:        //岩
            obstacle = SKSpriteNode(imageNamed: "rock")
            //パラメータを設定する
            obstacle.userData = ["number":itemNum,
                                 "durability":220.0]
        default:
            return    nil
        }
        
        obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        obstacle.name = NodeName.obstacle.rawValue
        obstacle.zPosition = NodeName.obstacle.zPosition()
        obstacle.position = position        //位置
        
        // 位置がおかしいので強制セット
        obstacle.position.y = 0
        
        self.baseNode.addChild(obstacle)
        
        //物理設定
        obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(obstacle.size.width/2),
                                                                  y: 0,
                                                                  width: obstacle.size.width,
                                                                  height: obstacle.size.height))
        obstacle.physicsBody!.categoryBitMask = NodeName.obstacle.category()
        obstacle.physicsBody!.collisionBitMask = NodeName.frame_ground.category()
        obstacle.physicsBody!.allowsRotation = false
        return obstacle
    }
    
    
}

