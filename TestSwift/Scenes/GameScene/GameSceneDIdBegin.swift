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
        
        //隕石が地球に落下！
        if bodyNameA.isEqual(kEarthName) {
            //落下パーティクル作成
            self.makeBomParticle(contact.contactPoint)
            self.makeSmokeParticle(contact.contactPoint)
            
            // 落下数更新
            self.fallenNumber = self.fallenNumber - 1
            self.setFallenNumber(Int32(self.fallenNumber))
        }
        
        //隕石が宇宙船に衝突！
        if bodyNameA.isEqual(kSpaceshipName) {
            //炎パーティクル作成
            self.makeFireParticle(contact.contactPoint)
            //スパークパーティクル作成
            self.makeSparkParticle(contact.contactPoint)
            //宇宙船を削除
            contact.bodyA.node!.removeFromParent()
            //ゲームオーバー
            self.showGameOver()
        } else if bodyNameA.isEqual(kMissileName) {
            //隕石とミサイルが衝突！
            //炎パーティクル作成
            self.makeFireParticle(contact.contactPoint)
            //スパークパーティクル作成
            self.makeSparkParticle(contact.contactPoint)
            //ミサイルを削除
            contact.bodyA.node?.removeFromParent()
            
            // スコア更新
            self.score += 10
            self.setScore(Int32(self.score))
        }
        
        //隕石を削除
        contact.bodyB.node?.removeFromParent()
    }
}
