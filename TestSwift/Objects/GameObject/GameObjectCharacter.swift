//
//  GameObjectCharacter.swift
//  TestSwift
//
//  Created by aship on 2020/12/01.
//

import SceneKit

extension GameObject {
    func setupCharacter() {
        character = Character()
        
        // keep a pointer to the physicsWorld from the character
        // because we will need it when updating the character's position
        character!.physicsWorld = self.scene!.physicsWorld
        
        self.scene!.rootNode.addChildNode(character!.node!)
    }
}
