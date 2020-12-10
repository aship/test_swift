//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        // bodyAとbodyBの衝突は、どちらがどちらかわからないのでチェックする
        // もし、bodyAがマシュマロだったら
        if contact.bodyA.node?.physicsBody?.categoryBitMask == category_marsh {
            // 衝突したbodyBがプレイヤーだったら、食べる
            if contact.bodyB.node == playerSprite {
                catchMarsh()
            }
            // 衝突したbodyBが地面だったら、ミスにする
            if contact.bodyB.node == groundSprite {
                onemiss(pos: contact.bodyA.node!.position)
            }
            // マシュマロのbodyAは消す
            contact.bodyA.node!.removeFromParent()
        }
        // もし、bodyBがマシュマロだったら
        if contact.bodyB.node?.physicsBody?.categoryBitMask == category_marsh {
            // 衝突したbodyAがプレイヤーだったら、食べる
            if contact.bodyA.node == playerSprite {
                catchMarsh()
            }
            // 衝突したbodyAが地面だったら、ミスにする
            if contact.bodyA.node == groundSprite {
                onemiss(pos: contact.bodyB.node!.position)
            }
            // マシュマロのbodyBは消す
            contact.bodyB.node!.removeFromParent()
        }
    }
    
    private func catchMarsh() {
        // スコアを追加する
        score += 10
        scoreLabel.text = "SCORE: \(score)"
        
        // 食べたところにハートを作る
        let heartSprite = SKSpriteNode(imageNamed: "heart.png")
        heartSprite.position = playerSprite.position
        self.addChild(heartSprite)
        
        // 【ハートに少しずつ大きく上に上がって消えるアクションをつける】
        // ハートを少しずつ大きくするアクション
        let action1 = SKAction.scale(to: 2.0,
                                     duration: 0.4)
        // ハートを上に100移動するアクション
        let action2 = SKAction.moveBy(x: 0,
                                      y: 100,
                                      duration: 0.4)
        // action1とaction2を同時に行う
        let actionG = SKAction.group([action1, action2])
        // ハートを削除するアクション
        let action3 = SKAction.removeFromParent()
        // actionGとaction3を順番に行う
        let actionS = SKAction.sequence([actionG, action3])
        // ハートにアクションをつける
        heartSprite.run(actionS)
    }
    
    // ミスをしたときの処理
    private func onemiss(pos: CGPoint) {
        let marsh = SKSpriteNode(imageNamed: "marsh2.png")
        marsh.position.x = pos.x
        marsh.position.y = -280
        marsh.setScale(0.5)
        self.addChild(marsh)
        
        // ミスを 1 追加する
        missCount = missCount + 1
        missLabel.text = "MISS: \(missCount)"
        // もし、ミスが 5 以上ならゲームオーバー
        if 5 <= missCount {
            // タイマーを停止する
            myTimer.invalidate()
            
            let scene = GameOverScene()
            scene.score = score
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            
            self.view?.presentScene(scene,
                                    transition: transition)
        }
    }
}
