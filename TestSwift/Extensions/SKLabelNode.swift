//
//  SKLabelNode.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension SKLabelNode {
    /// スコア表示用のSKLabelNodeを生成する
    class func createScoreLabel(x: Int, y: Int) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "Zapfino")
        node.position = CGPoint(x: x, y: y)
        node.fontSize = 25
        node.horizontalAlignmentMode = .right
        node.fontColor = UIColor.white
        return node
    }
}
