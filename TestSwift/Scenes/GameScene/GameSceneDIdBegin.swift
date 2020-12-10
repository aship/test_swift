//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyNameA: String = contact.bodyA.node!.name!
        let bodyNameB: String = contact.bodyB.node!.name!
        
     //   print(String(format: "A=%@ B=%@ Impulse=%.3f",
           //          bodyNameA,bodyNameB,contact.collisionImpulse))
        
        // 手裏剣が敵に当たった
        if (bodyNameA.isEqual(kEnemyName) && bodyNameB.isEqual(kWeponName)) ||
            (bodyNameB.isEqual(kEnemyName) && bodyNameA.isEqual(kWeponName)) {
            
            var enemy = CharactorNode()
            
            var wepon: SKNode
            
            if bodyNameB.isEqual(kWeponName) {
                enemy = contact.bodyA.node as! CharactorNode
                wepon = contact.bodyB.node!
            } else {
                enemy = contact.bodyB.node  as! CharactorNode
                wepon = contact.bodyA.node!
                
            }
            //敵のHPを減らす
            enemy.hp -= contact.collisionImpulse
            
            
            //敵をノックバックさせる
            enemy.isGetDamage = true
            enemy.getDamage()
            
            
            let angle: CGFloat = wepon.zRotation
            let x: CGFloat = sin(angle)*(contact.collisionImpulse/3)
            let y: CGFloat = cos(angle)*(contact.collisionImpulse/3)
            
            enemy.physicsBody!.applyImpulse(CGVector(dx: -x,
                                                     dy: y))
            wepon.removeFromParent()
            //手裏fadeAlphato:
            //敵死亡
            if enemy.hp <= 0 {
                //敵を透明にして消す
                enemy.physicsBody!.collisionBitMask = 0
                
                let ary: [SKAction] = [SKAction.fadeAlpha(to: 0,
                                                          duration: 0.25),
                                       SKAction.removeFromParent()]
                
                enemy.run(SKAction.sequence(ary))
            }
        }
        
        //敵がプレイヤーに接触
        if (bodyNameA.isEqual(kPlayerName) && bodyNameB.isEqual(kEnemyName)) ||
            (bodyNameB.isEqual(kPlayerName) && bodyNameA.isEqual(kEnemyName)) {
            
            var enemy = CharactorNode()
            
            if bodyNameB.isEqual(kEnemyName) {
                enemy = contact.bodyB.node as! CharactorNode
            } else {
                enemy = contact.bodyA.node as! CharactorNode
                
            }
            //敵がプレイヤーを攻撃する
            enemy.shoot() { [self] angle in
                //プレイヤーのHPを減らす
                self.playerNode.hp -= 10
                //プレイヤーにダメージパターン
                self.playerNode.isGetDamage = true
                self.playerNode.getDamage()
                //プレイヤー死亡
                if self.playerNode.hp <= 0 {
                    //プレイヤーを透明にして消す
                    self.playerNode.physicsBody!.collisionBitMask = 0
                    
                    let ary: [SKAction] = [SKAction.fadeAlpha(to: 0, duration: 0.25),
                                           SKAction.removeFromParent()]
                    
                    self.playerNode.run(SKAction.sequence(ary))
                }
                
            }
        }
    }
}
