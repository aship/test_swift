//
//  SceneObjectRenderer.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit
import AVFoundation

extension SceneObject {
    // MARK: SCNSceneRendererDelegate Conformance (Game Loop)
    
    // SceneKit calls this method exactly once per frame, so long as the SCNView object (or other SCNSceneRenderer object) displaying the scene is not paused.
    // Implement this method to add game logic to the rendering loop. Any changes you make to the scene graph during this method are immediately reflected in the displayed scene.
    
    func groundTypeFromMaterial(_ material: SCNMaterial) -> GroundType {
        if material == grassArea {
            return .grass
        }
        if material == waterArea {
            return .water
        }
        else {
            return .rock
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
     //   print("RENDEEE")
        
        // Reset some states every frame
        replacementPosition = nil
        maxPenetrationDistance = 0
        
        let scene = self.scnScene
        let direction = characterDirection()
        
        let groundNode = character.walkInDirection(direction,
                                                   time: time,
                                                   scene: scene,
                                                   groundTypeFromMaterial: groundTypeFromMaterial)
        
        if let groundNode = groundNode {
            updateCameraWithCurrentGround(groundNode)
        }
        
        // Flames are static physics bodies, but they are moved by an action - So we need to tell the physics engine that the transforms did change.
        for flame in flames {
            flame.physicsBody!.resetTransform()
        }
        
        // Adjust the volume of the enemy based on the distance to the character.
        var distanceToClosestEnemy = Float.infinity
        let characterPosition = SIMD3<Float>(character.node.position)
        
        for enemy in enemies {
            //distance to enemy
            let enemyTransform = float4x4(enemy.worldTransform)
            let enemyPosition = SIMD3<Float>(enemyTransform[3].x, enemyTransform[3].y, enemyTransform[3].z)
            let distance = simd.distance(characterPosition, enemyPosition)
            distanceToClosestEnemy = min(distanceToClosestEnemy, distance)
        }
        
        // Adjust sounds volumes based on distance with the enemy.
        if !gameIsComplete {
            if let mixer = flameThrowerSound!.audioNode as? AVAudioMixerNode {
                mixer.volume = 0.3 * max(0, min(1, 1 - ((distanceToClosestEnemy - 1.2) / 1.6)))
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didSimulatePhysicsAtTime time: TimeInterval) {
        // If we hit a wall, position needs to be adjusted
        if let position = replacementPosition {
            character.node.position = position
        }
    }
}
