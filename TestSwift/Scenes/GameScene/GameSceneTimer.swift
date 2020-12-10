//
//  GameSceneFuncss.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    // 移動開始タイマー
    @objc func moveStartTimer() {
        // プレイヤー移動開始
        self.moving = true
        self.playerNode.startMoveTextureAnimation()
    }    
}
