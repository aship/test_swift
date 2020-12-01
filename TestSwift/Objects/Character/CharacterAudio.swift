//
//  CharacterAudio.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension Character {
    // MARK: Audio
    
    func playFootStep() {
        if groundNode != nil && isWalking { // We are in the air, no sound to play.
            // Play a random step sound.
            let randSnd: Int = Int(Float(arc4random()) / Float(RAND_MAX) * Float(Character.stepsCount))
            let stepSoundIndex: Int = min(Character.stepsCount - 1, randSnd)
            characterNode.runAction(SCNAction.playAudio( steps[stepSoundIndex], waitForCompletion: false))
        }
    }
    
    func playJumpSound() {
        characterNode!.runAction(SCNAction.playAudio(jumpSound, waitForCompletion: false))
    }
    
    func playAttackSound() {
        characterNode!.runAction(SCNAction.playAudio(attackSound, waitForCompletion: false))
    }
}
