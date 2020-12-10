//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        //        print("touches begin")
        //        print("baseNode.speed")
        //        print(baseNode.speed)
        
        if baseNode.speed == 0 {
            baseNode.speed = 1
            player.physicsBody?.isDynamic = true
        }
        else if 0.0 < baseNode.speed {
            // プレイヤーに加えられている力をゼロにする
            player.physicsBody?.velocity = CGVector.zero
            // プレイヤーにy軸方向へ力を加える
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0,
                                                      dy: 16.0))
            
        }
        
        return
        
        
        
        if 0.0 < baseNode.speed {
            // ゲーム進行中のとき
            for touch in touches {
                _ = touch.location(in: self)
                
                
                print("basenode spped 1")
                
                // プレイヤーに加えられている力をゼロにする
                player.physicsBody?.velocity = CGVector.zero
                // プレイヤーにy軸方向へ力を加える
                player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 10.0))
            }
        } else if baseNode.speed == 0.0 && player.speed == 0.0 {
            print("GAME OVERR")
            // ゲームオーバー時はリスタート
            // 障害物を全て取り除く
            coralNode.removeAllChildren()
            
            // スコアをリセット
            score = 0
            scoreLabelNode.text = String(score)
            
            // プレイキャラを再配置
            player.position = CGPoint(x: screenWidth * 0.35,
                                      y: self.frame.size.height * 0.6)
            player.physicsBody?.velocity = CGVector.zero
            player.physicsBody?.collisionBitMask = ColliderType.World | ColliderType.Coral
            player.zRotation = 0.0
            
            // アニメーションを開始
            player.speed = 1.0
            baseNode.speed = 1.0
        }
        else if baseNode.speed == 0.0 {
            player.physicsBody?.isDynamic = true
            baseNode.speed = 1.0
            
            // プレイヤーに加えられている力をゼロにする
            player.physicsBody?.velocity = CGVector.zero
            // プレイヤーにy軸方向へ力を加える
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 10.0))
        }
    }
}
