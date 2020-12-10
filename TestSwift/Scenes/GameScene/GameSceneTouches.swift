//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/11/09.
//

import SpriteKit

extension GameScene {
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            // ロケットをタッチした位置の少し上に移動する
            rocket.position = touch.location(in: self)
            //rocket.position.y += 120
            rocketspk.particlePosition = rocket.position
        }
    }
}
