//
//  GameResultLayer.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit
/// ゲームリザルト用ノード
class GameResultLayer: SKNode {
    var touchHandler: (() -> ())?
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler?()
    }
}
