//
//  CharacterAnimations.swift
//  TestSwift
//
//  Created by aship on 2020/12/02.
//

import SceneKit

extension Character {
    func loadAnimations() {
        let idleAnimation = Character.loadAnimation(fromSceneNamed: "Art.scnassets/character/max_idle.scn")
        model.addAnimationPlayer(idleAnimation, forKey: "idle")
        idleAnimation.play()
        
        let walkAnimation = Character.loadAnimation(fromSceneNamed: "Art.scnassets/character/max_walk.scn")
        walkAnimation.speed = Character.speedFactor
        walkAnimation.stop()
        
        if Character.enableFootStepSound {
            walkAnimation.animation.animationEvents = [
                SCNAnimationEvent(keyTime: 0.1, block: { _, _, _ in self.playFootStep() }),
                SCNAnimationEvent(keyTime: 0.6, block: { _, _, _ in self.playFootStep() })
            ]
        }
        model.addAnimationPlayer(walkAnimation, forKey: "walk")
        
        let jumpAnimation = Character.loadAnimation(fromSceneNamed: "Art.scnassets/character/max_jump.scn")
        jumpAnimation.animation.isRemovedOnCompletion = false
        jumpAnimation.stop()
        jumpAnimation.animation.animationEvents = [SCNAnimationEvent(keyTime: 0, block: { _, _, _ in self.playJumpSound() })]
        model.addAnimationPlayer(jumpAnimation, forKey: "jump")
        
        let spinAnimation = Character.loadAnimation(fromSceneNamed: "Art.scnassets/character/max_spin.scn")
        spinAnimation.animation.isRemovedOnCompletion = false
        spinAnimation.speed = 1.5
        spinAnimation.stop()
        spinAnimation.animation.animationEvents = [SCNAnimationEvent(keyTime: 0, block: { _, _, _ in self.playAttackSound() })]
        model!.addAnimationPlayer(spinAnimation, forKey: "spin")
    }
}
