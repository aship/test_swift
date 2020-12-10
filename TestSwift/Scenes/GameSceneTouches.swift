//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/12/10.
//

import SpriteKit

extension GameScene {
    // タッチ開始時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        if let touch: AnyObject = touches.first {
            // シーン上のタッチされた位置を取得する
            let location = touch.location(in: self)
            // タッチされた位置にノードを移動させるアクションを作成する
            let action = SKAction.move(to: CGPoint(x: location.x, y: -200), duration: 0.2)
            // どんぶりのスプライトでアクションを実行する
            self.bowl?.run(action)
        }
    }
    
    // 指を動かしたときに呼ばれるメソッド
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: AnyObject = touches.first {
            // シーン上のタッチされた位置を取得する
            let location = touch.location(in: self)
            // タッチされた位置にノードを移動させるアクションを作成する
            let action = SKAction.move(to: CGPoint(x: location.x, y: -200), duration: 0.2)
            // どんぶりのスプライトでアクションを実行する
            self.bowl?.run(action)
        }
    }
}
