//
//  GameSceneLabel.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    /// スコアラベルを構築
    func setupScoreLabel() {
        // フォント名"Arial Bold"でラベルを作成
        scoreLabelNode = SKLabelNode(fontNamed: "Arial Bold")
        // フォント色を黄色に設定
        scoreLabelNode.fontColor = UIColor.black
        // 表示位置を設定
        scoreLabelNode.position = CGPoint(x: 0,
                                          y: 270)
        // 最前面に表示
        scoreLabelNode.zPosition = 100.0
        // スコアを表示
        scoreLabelNode.text = String(score)
        
        self.addChild(scoreLabelNode)
    }
}
