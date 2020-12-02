//
//  SceneObjectPhysics.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {
    // MARK: SCNPhysicsContactDelegate Conformance
    
    // To receive contact messages, you set the contactDelegate property of an SCNPhysicsWorld object.
    // SceneKit calls your delegate methods when a contact begins, when information about the contact changes, and when the contact ends.
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        contact.match(BitmaskCollision) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        contact.match(BitmaskCollectable) { (matching, _) in
            self.collectPearl(matching)
        }
        contact.match(BitmaskSuperCollectable) { (matching, _) in
            self.collectFlower(matching)
        }
        contact.match(BitmaskEnemy) { (_, _) in
            self.character.catchFire()
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        contact.match(BitmaskCollision) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }
    

    
    func characterNode(_ characterNode: SCNNode, hitWall wall: SCNNode, withContact contact: SCNPhysicsContact) {
        if characterNode.parent != character.node {
            return
        }
        
        if maxPenetrationDistance > contact.penetrationDistance {
            return
        }
        
        maxPenetrationDistance = contact.penetrationDistance
        
        var characterPosition = SIMD3<Float>(character.node.position)
        var positionOffset = SIMD3<Float>(contact.contactNormal) * Float(contact.penetrationDistance)
        positionOffset.y = 0
        characterPosition += positionOffset
        
        replacementPosition = SCNVector3(characterPosition)
    }
}
