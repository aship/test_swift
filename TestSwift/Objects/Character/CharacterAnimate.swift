//
//  CharacterAnimate.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension Character {
    // MARK: - Animating the character
    class func loadAnimation(fromSceneNamed sceneName: String) -> SCNAnimationPlayer {
        let scene = SCNScene( named: sceneName )!
        // find top level animation
        var animationPlayer: SCNAnimationPlayer! = nil
        scene.rootNode.enumerateChildNodes { (child, stop) in
            if !child.animationKeys.isEmpty {
                animationPlayer = child.animationPlayer(forKey: child.animationKeys[0])
                stop.pointee = true
            }
        }
        return animationPlayer
    }
    
    var isAttacking: Bool {
        return attackCount > 0
    }
    
    func attack() {
        attackCount += 1
        model.animationPlayer(forKey: "spin")?.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.attackCount -= 1
        }
        spinParticleAttach.addParticleSystem(spinCircleParticle)
    }
            
    func characterDirection(withPointOfView pointOfView: SCNNode?) -> SIMD3<Float> {
        let controllerDir = self.direction
        if controllerDir.allZero() {
            return SIMD3<Float>.zero
        }
        
        var directionWorld = SIMD3<Float>.zero
        if let pov = pointOfView {
            let p1 = pov.presentation.simdConvertPosition(SIMD3<Float>(controllerDir.x, 0.0, controllerDir.y), to: nil)
            let p0 = pov.presentation.simdConvertPosition(SIMD3<Float>.zero, to: nil)
            directionWorld = p1 - p0
            directionWorld.y = 0
            if simd_any(directionWorld != SIMD3<Float>.zero) {
                let minControllerSpeedFactor = Float(0.2)
                let maxControllerSpeedFactor = Float(1.0)
                let speed = simd_length(controllerDir) * (maxControllerSpeedFactor - minControllerSpeedFactor) + minControllerSpeedFactor
                directionWorld = speed * simd_normalize(directionWorld)
            }
        }
        return directionWorld
    }
    
    func resetCharacterPosition() {
        characterNode.simdPosition = Character.initialPosition
        downwardAcceleration = 0
    }
}
