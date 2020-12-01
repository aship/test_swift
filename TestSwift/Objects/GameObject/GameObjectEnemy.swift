//
//  GameObjectEnemy.swift
//  TestSwift
//
//  Created by aship on 2020/12/01.
//

import SceneKit
import GameplayKit

extension GameObject {
    func setupEnemies() {
        self.enemy1 = self.scene?.rootNode.childNode(withName: "enemy1", recursively: true)
        self.enemy2 = self.scene?.rootNode.childNode(withName: "enemy2", recursively: true)
        
        let gkScene = GKScene()
        
        // Player
        let playerEntity = GKEntity()
        gkScene.addEntity(playerEntity)
        playerEntity.addComponent(GKSCNNodeComponent(node: character!.node))
        
        let playerComponent = PlayerComponent()
        playerComponent.isAutoMoveNode = false
        playerComponent.character = self.character
        playerEntity.addComponent(playerComponent)
        playerComponent.positionAgentFromNode()
        
        // Chaser
        let chaserEntity = GKEntity()
        gkScene.addEntity(chaserEntity)
        chaserEntity.addComponent(GKSCNNodeComponent(node: self.enemy1!))
        let chaser = ChaserComponent()
        chaserEntity.addComponent(chaser)
        chaser.player = playerComponent
        chaser.positionAgentFromNode()
        
        // Scared
        let scaredEntity = GKEntity()
        gkScene.addEntity(scaredEntity)
        scaredEntity.addComponent(GKSCNNodeComponent(node: self.enemy2!))
        let scared = ScaredComponent()
        scaredEntity.addComponent(scared)
        scared.player = playerComponent
        scared.positionAgentFromNode()
        
        // animate enemies (move up and down)
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = NSValue(scnVector3: SCNVector3(0, 0.1, 0))
        anim.toValue = NSValue(scnVector3: SCNVector3(0, -0.1, 0))
        anim.isAdditive = true
        anim.repeatCount = .infinity
        anim.autoreverses = true
        anim.duration = 1.2
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        self.enemy1!.addAnimation(anim, forKey: "")
        self.enemy2!.addAnimation(anim, forKey: "")
        
        self.gkScene = gkScene
    }
}
