//
//  GameObjectEtc.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

import SceneKit

extension GameObject {
    // MARK: - Init
    func resetPlayerPosition() {
        character!.queueResetCharacterPosition()
    }
    
    // MARK: - cinematic
    
    func startCinematic() {
        playingCinematic = true
        character!.node!.isPaused = true
    }
    
    func stopCinematic() {
        playingCinematic = false
        character!.node!.isPaused = false
    }
    
    // MARK: - particles
    
    func particleSystems(with kind: ParticleKind) -> [SCNParticleSystem] {
        return particleSystems[kind.rawValue]
    }
    
    func addParticles(with kind: ParticleKind, withTransform transform: SCNMatrix4) {
        let particles = particleSystems(with: kind)
        
        for ps: SCNParticleSystem in particles {
            scene.addParticleSystem(ps, transform: transform)
        }
    }
}
