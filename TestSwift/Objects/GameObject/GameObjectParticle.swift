//
//  GameObjectParticle.swift
//  TestSwift
//
//  Created by aship on 2020/12/01.
//

import SceneKit

extension GameObject {
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
}
