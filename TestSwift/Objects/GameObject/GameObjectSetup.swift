//
//  GameObjectSetup.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

import GameController
import GameplayKit
import SceneKit

extension GameObject {
    func setupGameObject() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        guard let controller = GCController.controllers().first else {
            return
        }
        
        registerGameObject(controller)
    }
    
    func setupEnemies() {
        self.enemy1 = self.scene.rootNode.childNode(withName: "enemy1", recursively: true)
        self.enemy2 = self.scene.rootNode.childNode(withName: "enemy2", recursively: true)
        
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
    
    func loadParticleSystems(atPath path: String) -> [SCNParticleSystem] {
        let url = URL(fileURLWithPath: path)
        let directory = url.deletingLastPathComponent()
        
        let fileName = url.lastPathComponent
        let ext: String = url.pathExtension
        
        if ext == "scnp" {
            return [SCNParticleSystem(named: fileName, inDirectory: directory.relativePath)!]
        } else {
            var particles = [SCNParticleSystem]()
            let scene = SCNScene(named: fileName, inDirectory: directory.relativePath, options: nil)
            scene!.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
                if node.particleSystems != nil {
                    particles += node.particleSystems!
                }
            })
            return particles
        }
    }
    
    func setupParticleSystem() {
        particleSystems[ParticleKind.collect.rawValue] = loadParticleSystems(atPath: "Art.scnassets/particles/collect.scnp")
        particleSystems[ParticleKind.collectBig.rawValue] = loadParticleSystems(atPath: "Art.scnassets/particles/key_apparition.scn")
        particleSystems[ParticleKind.enemyExplosion.rawValue] = loadParticleSystems(atPath: "Art.scnassets/particles/enemy_explosion.scn")
        particleSystems[ParticleKind.keyApparition.rawValue] = loadParticleSystems(atPath: "Art.scnassets/particles/key_apparition.scn")
        particleSystems[ParticleKind.unlockDoor.rawValue] = loadParticleSystems(atPath: "Art.scnassets/particles/unlock_door.scn")
    }
    
    func setupPlatforms() {
        let PLATFORM_MOVE_OFFSET = Float(1.5)
        let PLATFORM_MOVE_SPEED = Float(0.5)
        
        var alternate: Float = 1
        // This could be done in the editor using the action editor.
        scene.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.name == "mobilePlatform" && !node.childNodes.isEmpty {
                node.simdPosition = simd_float3(
                    node.simdPosition.x - (alternate * PLATFORM_MOVE_OFFSET / 2.0), node.simdPosition.y, node.simdPosition.z)
                
                let moveAction = SCNAction.move(by: SCNVector3(alternate * PLATFORM_MOVE_OFFSET, 0, 0),
                                                duration: TimeInterval(1 / PLATFORM_MOVE_SPEED))
                moveAction.timingMode = .easeInEaseOut
                node.runAction(SCNAction.repeatForever(SCNAction.sequence([moveAction, moveAction.reversed()])))
                
                alternate = -alternate // alternate movement of platforms to desynchronize them
                
                node.enumerateChildNodes({ (_ child: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) in
                    if child.name == "particles_platform" {
                        child.particleSystems?[0].orientationDirection = SCNVector3(0, 1, 0)
                    }
                })
            }
        })
    }
}
