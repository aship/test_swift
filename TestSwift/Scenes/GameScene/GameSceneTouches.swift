//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    // タッチイベント時
    override func touchesBegan(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        // タッチしたときのシーン上の位置を求める
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        // プレイヤーの現在位置を取得
        if let playerLocation = self.player?.sprite?.position {
            // タッチ位置とプレイヤーの位置との差を求める
            let x = touchLocation.x - playerLocation.x
            let y = touchLocation.y - playerLocation.y

            // 絶対値が大きい方向を求める
            var nextDirection: Direction
            if abs(x) > abs(y) {
                nextDirection = x > 0 ? .Right : .Left
            } else {
                nextDirection = y > 0 ? .Up : .Down
            }
            
            if let player = self.player {
                // プレイヤーが方向転換可能であれば
                if player.canRotate(direction: nextDirection) {
                    // 次回の方向として反映する
                    player.nextDirection = nextDirection
                    // プレイヤーの動きが止まっていれば動かす
                    player.startMoving()
                }
            }
        }
    }
}
