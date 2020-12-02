/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the main character, including its animations, sounds and direction.
 */

import Foundation
import SceneKit
import simd

// Returns plane / ray intersection distance from ray origin.
func planeIntersect(planeNormal: SIMD3<Float>,
                    planeDist: Float,
                    rayOrigin: SIMD3<Float>,
                    rayDirection: SIMD3<Float>) -> Float {
    return (planeDist - simd_dot(planeNormal, rayOrigin)) / simd_dot(planeNormal, rayDirection)
}

class Character: NSObject {
    
    static let speedFactor: CGFloat = 2.0
    static let stepsCount = 10
    
    static let initialPosition = SIMD3<Float>(0.1, -0.2, 0)
    
    // some constants
    static let gravity = Float(0.004)
    static let jumpImpulse = Float(0.1)
    static let minAltitude = Float(-10)
    static let enableFootStepSound = true
    static let collisionMargin = Float(0.04)
    static let modelOffset = SIMD3<Float>(0, -collisionMargin, 0)
    static let collisionMeshBitMask = 8
    
    enum GroundType: Int {
        case grass
        case rock
        case water
        case inTheAir
        case count
    }
    
    // Character handle
    var characterNode: SCNNode! // top level node
    var characterOrientation: SCNNode! // the node to rotate to orient the character
    var model: SCNNode! // the model loaded from the character file
    
    // Physics
    var characterCollisionShape: SCNPhysicsShape?
    var collisionShapeOffsetFromModel = SIMD3<Float>.zero
    var downwardAcceleration: Float = 0
    
    // Jump
    var controllerJump: Bool = false
    var jumpState: Int = 0
    var groundNode: SCNNode?
    var groundNodeLastPosition = SIMD3<Float>.zero
    var baseAltitude: Float = 0
    var targetAltitude: Float = 0
    
    // void playing the step sound too often
    var lastStepFrame: Int = 0
    var frameCounter: Int = 0
    
    // Direction
    var previousUpdateTime: TimeInterval = 0
    var controllerDirection = SIMD2<Float>.zero
    
    // states
    var attackCount: Int = 0
    var lastHitTime: TimeInterval = 0
    
    var shouldResetCharacterPosition = false
    
    // Particle systems
    var jumpDustParticle: SCNParticleSystem!
    var fireEmitter: SCNParticleSystem!
    var smokeEmitter: SCNParticleSystem!
    var whiteSmokeEmitter: SCNParticleSystem!
    var spinParticle: SCNParticleSystem!
    var spinCircleParticle: SCNParticleSystem!
    
    var spinParticleAttach: SCNNode!
    
    var fireEmitterBirthRate: CGFloat = 0.0
    var smokeEmitterBirthRate: CGFloat = 0.0
    var whiteSmokeEmitterBirthRate: CGFloat = 0.0
    
    // Sound effects
    var aahSound: SCNAudioSource!
    var ouchSound: SCNAudioSource!
    var hitSound: SCNAudioSource!
    var hitEnemySound: SCNAudioSource!
    var explodeEnemySound: SCNAudioSource!
    var catchFireSound: SCNAudioSource!
    var jumpSound: SCNAudioSource!
    var attackSound: SCNAudioSource!
    var steps = [SCNAudioSource](repeating: SCNAudioSource(),
                                 count: Character.stepsCount )
    
    private(set) var offsetedMark: SCNNode?
    
    // actions
    var isJump: Bool = false
    var direction = SIMD2<Float>()
    var physicsWorld: SCNPhysicsWorld?
    
    var isBurning: Bool = false {
        didSet {
            if isBurning == oldValue {
                return
            }
            //walk faster when burning
            let oldSpeed = walkSpeed
            walkSpeed = oldSpeed
            
            if isBurning {
                model.runAction(SCNAction.sequence([
                    SCNAction.playAudio(catchFireSound, waitForCompletion: false),
                    SCNAction.playAudio(ouchSound, waitForCompletion: false),
                    SCNAction.repeatForever(SCNAction.sequence([
                        SCNAction.fadeOpacity(to: 0.01, duration: 0.1),
                        SCNAction.fadeOpacity(to: 1.0, duration: 0.1)
                    ]))
                ]))
                whiteSmokeEmitter.birthRate = 0
                fireEmitter.birthRate = fireEmitterBirthRate
                smokeEmitter.birthRate = smokeEmitterBirthRate
            } else {
                model.removeAllAudioPlayers()
                model.removeAllActions()
                model.opacity = 1.0
                model.runAction(SCNAction.playAudio(aahSound, waitForCompletion: false))
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.0
                whiteSmokeEmitter.birthRate = whiteSmokeEmitterBirthRate
                fireEmitter.birthRate = 0
                smokeEmitter.birthRate = 0
                SCNTransaction.commit()
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 5.0
                whiteSmokeEmitter.birthRate = 0
                SCNTransaction.commit()
            }
        }
    }
    
    // MARK: - Controlling the character
    
    var directionAngle: CGFloat = 0.0 {
        didSet {
            characterOrientation.runAction(
                SCNAction.rotateTo(x: 0.0, y: directionAngle, z: 0.0, duration: 0.1, usesShortestUnitArc:true))
        }
    }
    
    var walkSpeed: CGFloat = 1.0 {
        didSet {
            let burningFactor: CGFloat = isBurning ? 2: 1
            model.animationPlayer(forKey: "walk")?.speed = Character.speedFactor * walkSpeed * burningFactor
        }
    }
    
    var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                // Update node animation.
                if isWalking {
                    model.animationPlayer(forKey: "walk")?.play()
                } else {
                    model.animationPlayer(forKey: "walk")?.stop(withBlendOutDuration: 0.2)
                }
            }
        }
    }
    
    var isAttacking: Bool {
        return attackCount > 0
    }
    
    var node: SCNNode! {
        return characterNode
    }
    
    override init() {
        super.init()
        
        loadCharacter()
        loadParticles()
        loadSounds()
        loadAnimations()
    }
}
