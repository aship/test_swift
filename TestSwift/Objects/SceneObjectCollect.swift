//
//  SceneObjectCollect.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {
    
    // MARK: Collecting Items
    
    func removeNode(_ node: SCNNode, soundToPlay sound: SCNAudioSource) {
        if let parentNode = node.parent {
            let soundEmitter = SCNNode()
            soundEmitter.position = node.position
            parentNode.addChildNode(soundEmitter)
            
            soundEmitter.runAction(SCNAction.sequence([
                                                        SCNAction.playAudio(sound, waitForCompletion: true),
                                                        SCNAction.removeFromParentNode()]))
            
            node.removeFromParentNode()
        }
    }
    
    
    func collectPearl(_ pearlNode: SCNNode) {
        if pearlNode.parent != nil {
            removeNode(pearlNode, soundToPlay:collectPearlSound)
            collectedPearlsCount += 1
        }
    }
    
    
    
    func collectFlower(_ flowerNode: SCNNode) {
        if flowerNode.parent != nil {
            // Emit particles.
            var particleSystemPosition = flowerNode.worldTransform
            particleSystemPosition.m42 += 0.1
            #if os(iOS) || os(tvOS)
            self.scnScene.addParticleSystem(collectFlowerParticleSystem, transform: particleSystemPosition)
            #elseif os(OSX)
            self.scnScene.addParticleSystem(collectFlowerParticleSystem, transform: particleSystemPosition)
            #endif
            
            // Remove the flower from the scene.
            removeNode(flowerNode, soundToPlay:collectFlowerSound)
            collectedFlowersCount += 1
        }
    }
    
    
}
