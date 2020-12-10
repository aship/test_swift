//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    // MARK: - SKPhysicsContactDelegateプロトコルの実装
    
    /// 衝突開始時のイベントハンドラ
    func didBegin(_ contact: SKPhysicsContact) {
        print("didBegin \(counter)")
        counter = counter + 1
        //    return
        
        // 既にゲームオーバー状態の場合
        if baseNode.speed <= 0.0 {
            return
        }
        
        let rawScoreType = ColliderType.Score
        let rawNoneType = ColliderType.None
        
        if (contact.bodyA.categoryBitMask & rawScoreType) == rawScoreType ||
            (contact.bodyB.categoryBitMask & rawScoreType) == rawScoreType {
            // スコアを加算しラベルに反映
            score = score + 1
            scoreLabelNode.text = String(score)
            
            // スコアラベルをアニメーション
            let scaleUpAnim = SKAction.scale(to: 1.5, duration: 0.1)
            let scaleDownAnim = SKAction.scale(to: 1.0, duration: 0.1)
            scoreLabelNode.run(SKAction.sequence([scaleUpAnim, scaleDownAnim]))
            
            // スコアカウントアップに設定されているcontactTestBitMaskを変更
            if (contact.bodyA.categoryBitMask & rawScoreType) == rawScoreType {
                contact.bodyA.categoryBitMask = ColliderType.None
                contact.bodyA.contactTestBitMask = ColliderType.None
            } else {
                contact.bodyB.categoryBitMask = ColliderType.None
                contact.bodyB.contactTestBitMask = ColliderType.None
            }
        } else if (contact.bodyA.categoryBitMask & rawNoneType) == rawNoneType ||
                    (contact.bodyB.categoryBitMask & rawNoneType) == rawNoneType {
            // なにもしない
        } else {
            // baseNodeに追加されたものすべてのアニメーションを停止
            baseNode.speed = 0.0
            
            // プレイキャラのBitMaskを変更
            player.physicsBody?.collisionBitMask = ColliderType.World
            // プレイキャラに回転アニメーションを実行
            let rolling = SKAction.rotate(byAngle: CGFloat(Double.pi) * player.position.y * 0.01, duration: 1.0)
            player.run(rolling, completion:{
                // アニメーション終了時にプレイキャラのアニメーションを停止
                self.player.speed = 0.0
            })
        }
    }
    
}
