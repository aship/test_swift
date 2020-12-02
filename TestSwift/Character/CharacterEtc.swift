//
//  CharacterEtc.swift
//  TestSwift
//
//  Created by aship on 2020/11/26.
//

import SceneKit

extension Character {
    // MARK: Dealing with fire
    func catchFire() {
        if isInvincible == false {
            isInvincible = true
            node.runAction(SCNAction.sequence([
                SCNAction.playAudio(catchFireSound, waitForCompletion: false),
                SCNAction.repeat(SCNAction.sequence([
                    SCNAction.fadeOpacity(to: 0.01, duration: 0.1),
                    SCNAction.fadeOpacity(to: 1.0, duration: 0.1)
                    ]), count: 7),
                SCNAction.run { _ in self.isInvincible = false } ]))
        }
        
        isBurning = true
        
        // start fire + smoke
        fireEmitter.particleSystem.birthRate = fireEmitter.birthRate
        smokeEmitter.particleSystem.birthRate = smokeEmitter.birthRate
        
        // walk faster
        walkSpeed = 2.3
    }
    
    func haltFire() {
        if isBurning {
            isBurning = false
            
            node.runAction(SCNAction.sequence([
                SCNAction.playAudio(haltFireSound, waitForCompletion: true),
                SCNAction.playAudio(reliefSound, waitForCompletion: false)])
            )
            
            // stop fire and smoke
            fireEmitter.particleSystem.birthRate = 0
            SCNTransaction.animateWithDuration(1.0) {
                self.smokeEmitter.particleSystem.birthRate = 0
            }
            
            // start white smoke
            whiteSmokeEmitter.particleSystem.birthRate = whiteSmokeEmitter.birthRate
            
            // progressively stop white smoke
            SCNTransaction.animateWithDuration(5.0) {
                self.whiteSmokeEmitter.particleSystem.birthRate = 0
            }
            
            // walk normally
            walkSpeed = 1.0
        }
    }
    
    // MARK: Dealing with sound
    

    func playFootStep() {
        if groundType != .inTheAir { // We are in the air, no sound to play.
            // Play a random step sound.
            let soundsCount = steps[groundType.rawValue].count
            let stepSoundIndex = Int(arc4random_uniform(UInt32(soundsCount)))
            node.runAction(SCNAction.playAudio(steps[groundType.rawValue][stepSoundIndex], waitForCompletion: false))
        }
    }
    
    
}
