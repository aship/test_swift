//
//  GameObjectPhysics.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    func setupPhysics() {
        //make sure all objects only collide with the character
        self.scene?.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
            node.physicsBody?.collisionBitMask = Int(Bitmask.character.rawValue)
        })
    }
    
    func setupCollisions() {
        // load the collision mesh from another scene and merge into main scene
        let collisionsScene = SCNScene( named: "Art.scnassets/collision.scn" )
        collisionsScene!.rootNode.enumerateChildNodes { (_ child: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) in
            child.opacity = 0.0
            self.scene?.rootNode.addChildNode(child)
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld,
                      didBegin contact: SCNPhysicsContact) {
        
        // triggers
        if contact.nodeA.physicsBody!.categoryBitMask == Bitmask.trigger.rawValue {
            trigger(contact.nodeA)
        }
        if contact.nodeB.physicsBody!.categoryBitMask == Bitmask.trigger.rawValue {
            trigger(contact.nodeB)
        }
        
        // collectables
        if contact.nodeA.physicsBody!.categoryBitMask == Bitmask.collectable.rawValue {
            collect(contact.nodeA)
        }
        if contact.nodeB.physicsBody!.categoryBitMask == Bitmask.collectable.rawValue {
            collect(contact.nodeB)
        }
    }
}
