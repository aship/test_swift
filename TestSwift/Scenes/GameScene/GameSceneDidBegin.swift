//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node {
                //衝突したオブジェクトにmonsterが含まれていたらポイント加算
                if nodeA.name == "monster1" ||
                    nodeB.name == "monster1" ||
                    nodeA.name == "monster2" ||
                    nodeB.name == "monster2" ||
                    nodeA.name == "monster3" ||
                    nodeB.name == "monster3"{
                    //ここに衝突が発生したときの処理を書く
                    //効果音を再生する
                    ball.run(playSound)
                    
                    //パーティクルの作成
                    let particle:SKEmitterNode! = SKEmitterNode(fileNamed: "MyParticle.sks")
                    self.addChild(particle)
                    
                    //１秒後にパーティクルを削除する ぶつかるたびにパーティクルが増えて重くなる
                    let removeAction = SKAction.removeFromParent()
                    let durationAction = SKAction.wait(forDuration: 1)
                    let sequenceAction = SKAction.sequence([durationAction,removeAction])
                    particle.run(sequenceAction)
                    
                    //ボールの位置にパーティクル移動
                    particle.position = CGPoint(x: ball.position.x,y: ball.position.y)
                    particle.alpha = 1
                    
                    let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
                    particle.run(fadeAction)
                    
                    //得点を加算する。
                    count += 10
                    let pointString:String = "\(count)点"
                    pointLabel.text = pointString
                }
            }
        }
    }
}
