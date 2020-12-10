//
//  TouchScene.swift
//  TestSwift
//
//  Created by aship on 2020/11/07.
//

import SpriteKit

// 一枚絵を表示するシーン
class TouchScene: SKScene {
    // 画面タッチ時
    override func touchesBegan(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        // フリップトランジション
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        
        // GameSceneを初期化する
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        scene.size = CGSize(width: screenWidth,
                            height: screenHeight)
        
        // トランジションを適用しながらGameSceneに遷移する
        self.view?.presentScene(scene, transition: transition)
    }
}
