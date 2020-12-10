//
//  GameSceneDidSimulatePhysics.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    override func didSimulatePhysics() {
        self.enumerateChildNodes(withName: kMeteorName) { node, stop in
            if node.position.y < -(screenHeight / 2) ||
                node.position.x < -(screenWidth / 2) ||
                node.position.x > (screenWidth / 2) {
                node.removeFromParent()
            }
        }
        
        self.enumerateChildNodes(withName: kMissileName) { node, stop in
            if node.position.y < -(screenHeight / 2) ||
                screenHeight / 2 < node.position.y ||
                node.position.x < -(screenWidth / 2) ||
                screenWidth / 2 < node.position.x {
                node.removeFromParent()
            }
        }
    }
}
