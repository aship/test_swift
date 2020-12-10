//
//  GameSceneUpdate.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    override func update(_ currentTime: CFTimeInterval) {
        let leftBoundary = -1 * screenWidth / 2 - 20
        let rightBoundary = screenWidth / 2 + 20
        
        // 障害物を移動させる
        for i in 0 ..< pinCount {
            pinSprite[i].position.x += pinVX[i]
            
            // もし、画面の左より外に出たら右に移動する
            if pinSprite[i].position.x < leftBoundary {
                pinSprite[i].position.x = rightBoundary
            }
            
            // もし、画面の右より外に出たら左に移動する
            if rightBoundary < pinSprite[i].position.x {
                pinSprite[i].position.x = leftBoundary
            }
        }
    }
}
