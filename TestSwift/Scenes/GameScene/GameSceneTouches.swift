//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            // ラベル人をタッチした位置に横移動する
            playerSprite.position.x = touch.location(in: self).x
        }
    }
}
