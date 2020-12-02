//
//  SceneObjectSetup.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {
    // MARK: Scene Setup
    
    func setupEtc() {
        
        // Configure particle systems
        collectFlowerParticleSystem = SCNParticleSystem(named: "collect.scnp", inDirectory: nil)
        collectFlowerParticleSystem.loops = false
        confettiParticleSystem = SCNParticleSystem(named: "confetti.scnp",
                                                   inDirectory: nil)
        
        // Add the character to the scene.
        scnScene.rootNode.addChildNode(character.node)
        
        let startPosition = scnScene.rootNode.childNode(withName: "startingPoint",
                                                        recursively: true)!
        character.node.transform = startPosition.transform
        
        // Retrieve various game elements in one traversal
        var collisionNodes = [SCNNode]()
        scnScene.rootNode.enumerateChildNodes { (node, _) in
            switch node.name {
            case .some("flame"):
                node.physicsBody!.categoryBitMask = BitmaskEnemy
                self.flames.append(node)
                
            case .some("enemy"):
                self.enemies.append(node)
                
            case let .some(s) where s.range(of: "collision") != nil:
                collisionNodes.append(node)
                
            default:
                break
            }
        }
        
        for node in collisionNodes {
            node.isHidden = false
            setupCollisionNode(node)
        }
    }
        
    func setupCollisionNode(_ node: SCNNode) {
        if let geometry = node.geometry {
            // Collision meshes must use a concave shape for intersection correctness.
            node.physicsBody = SCNPhysicsBody.static()
            node.physicsBody!.categoryBitMask = BitmaskCollision
            node.physicsBody!.physicsShape = SCNPhysicsShape(node: node,
                                                             options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron as NSString])
            
            // Get grass area to play the right sound steps
            if geometry.firstMaterial!.name == "grass-area" {
                if grassArea != nil {
                    geometry.firstMaterial = grassArea
                } else {
                    grassArea = geometry.firstMaterial
                }
            }
            
            // Get the water area
            if geometry.firstMaterial!.name == "water" {
                waterArea = geometry.firstMaterial
            }
            
            // Temporary workaround because concave shape created
            // from geometry instead of node fails
            let childNode = SCNNode()
            node.addChildNode(childNode)
            childNode.isHidden = true
            childNode.geometry = node.geometry
            node.geometry = nil
            node.isHidden = false
            
            if node.name == "water" {
                node.physicsBody!.categoryBitMask = BitmaskWater
            }
        }
        
        for childNode in node.childNodes {
            if childNode.isHidden == false {
                setupCollisionNode(childNode)
            }
        }
    }
    
    func setupBgm() {
        let rootNode = self.scnScene.rootNode
        
        let audioSource = SCNAudioSource(name: "music.m4a",
                                         volume: 0.25,
                                         positional: false,
                                         loops: true,
                                         shouldStream: true)
        
        let audioPlayer = SCNAudioPlayer(source: audioSource)
        rootNode.addAudioPlayer(audioPlayer)
        
        let play = SCNAction.playAudio(audioSource,
                                       waitForCompletion: true)
        rootNode.runAction(play)
    }
    
    func setupSounds() {
        // Get an arbitrary node to attach the sounds to.
        let rootNode = self.scnScene.rootNode
        
        rootNode.addAudioPlayer(SCNAudioPlayer(source: SCNAudioSource(name: "wind.m4a",
                                                                      volume: 0.3,
                                                                      positional: false,
                                                                      loops: true,
                                                                      shouldStream: true)))
        flameThrowerSound = SCNAudioPlayer(source: SCNAudioSource(name: "flamethrower.mp3",
                                                                  volume: 0,
                                                                  positional: false,
                                                                  loops: true))
        rootNode.addAudioPlayer(flameThrowerSound)
        
        collectPearlSound = SCNAudioSource(name: "collect1.mp3",
                                           volume: 0.5)
        collectFlowerSound = SCNAudioSource(name: "collect2.mp3")
        victoryMusic = SCNAudioSource(name: "Music_victory.mp3",
                                      volume: 0.5,
                                      shouldLoad: false)
    }
}
