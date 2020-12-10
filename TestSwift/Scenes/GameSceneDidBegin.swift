//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/12/10.
//

import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        // 衝突した一方が落下判定用シェイプだったら
        if contact.bodyA.node == self.lowestShape || contact.bodyB.node == self.lowestShape {
            // ゲームオーバースプライトを表示
            let sprite = SKSpriteNode(imageNamed: "gameover")
            //sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
            self.addChild(sprite)
            
            // アクションを停止させる
            self.isPaused = true
            
            // タイマーを止める
            self.timer?.invalidate()
        }
    }
}
