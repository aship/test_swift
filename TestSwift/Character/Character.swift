/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This class manages the main character, including its animations, sounds and direction.
*/

import SceneKit

enum GroundType: Int {
    case grass
    case rock
    case water
    case inTheAir
    case count
}

typealias ParticleEmitter = (node: SCNNode,
                                     particleSystem: SCNParticleSystem,
                                     birthRate: CGFloat)

class Character {
    // MARK: Retrieving nodes
    
    let node = SCNNode()
    
    // MARK: Controlling the character
    
    static let speedFactor = Float(1.538)
    
    var groundType = GroundType.inTheAir
    var previousUpdateTime = TimeInterval(0.0)
    var accelerationY = SCNFloat(0.0) // Simulate gravity
    
    var directionAngle: SCNFloat = 0.0 {
        didSet {
            if directionAngle != oldValue {
                node.runAction(SCNAction.rotateTo(x: 0.0,
                                                  y: CGFloat(directionAngle),
                                                  z: 0.0,
                                                  duration: 0.1,
                                                  usesShortestUnitArc: true))
            }
        }
    }
    
    var isBurning = false
    var isInvincible = false
    
    var fireEmitter: ParticleEmitter! = nil
    var smokeEmitter: ParticleEmitter! = nil
    var whiteSmokeEmitter: ParticleEmitter! = nil
    
    // MARK: Animating the character
    
    var walkAnimation: CAAnimation!
    
    var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                // Update node animation.
                if isWalking {
                    node.addAnimation(walkAnimation, forKey: "walk")
                } else {
                    node.removeAnimation(forKey: "walk", fadeOutDuration: 0.2)
                }
            }
        }
    }
    
    var walkSpeed: Float = 1.0 {
        didSet {
            // remove current walk animation if any.
            let wasWalking = isWalking
            if wasWalking {
                isWalking = false
            }

            walkAnimation.speed = Character.speedFactor * walkSpeed
            
            // restore walk animation if needed.
            isWalking = wasWalking
        }
    }
    
    var reliefSound: SCNAudioSource
    var haltFireSound: SCNAudioSource
    var catchFireSound: SCNAudioSource
    
    var steps = [[SCNAudioSource]](repeating: [], count: GroundType.count.rawValue)
    
    // MARK: Initialization
    
    init() {
        
        // MARK: Load character from external file
        
        // The character is loaded from a .scn file and stored in an intermediate
        // node that will be used as a handle to manipulate the whole group at once
        
        let characterScene = SCNScene(named: "game.scnassets/panda.scn")!
        let characterTopLevelNode = characterScene.rootNode.childNodes[0]
        node.addChildNode(characterTopLevelNode)
        
        print("characterTopLevelNode NEMAEEEE \(String(describing: characterTopLevelNode.name))")
        print("node.position \(node.position)")
        print("characterTopLevelNode.position \(characterTopLevelNode.position)")
        
        // MARK: Configure collision capsule
        
        // Collisions are handled by the physics engine. The character is approximated by
        // a capsule that is configured to collide with collectables, enemies and walls
        
        let (min, max) = node.boundingBox
        let collisionCapsuleRadius = CGFloat((max.x - min.x) * 0.4)
        let collisionCapsuleHeight = CGFloat(max.y - min.y)
        
        let characterCollisionNode = SCNNode()
        characterCollisionNode.name = "collider"
        characterCollisionNode.position = SCNVector3(0.0, collisionCapsuleHeight * 0.51, 0.0) // a bit too high so that the capsule does not hit the floor
        
        characterCollisionNode.physicsBody = SCNPhysicsBody(type: .kinematic,
                                                            shape:SCNPhysicsShape(geometry: SCNCapsule(capRadius: collisionCapsuleRadius, height: collisionCapsuleHeight), options:nil))
        
        characterCollisionNode.physicsBody!.contactTestBitMask = BitmaskSuperCollectable |
                                                                BitmaskCollectable |
                                                                BitmaskCollision |
                                                                BitmaskEnemy
        node.addChildNode(characterCollisionNode)
        
        
        // MARK: Load particle systems
        
        // Particle systems were configured in the SceneKit Scene Editor
        // They are retrieved from the scene and their birth rate are stored for later use
        
        func particleEmitterWithName(_ name: String) -> ParticleEmitter {
            let emitter: ParticleEmitter
            emitter.node = characterTopLevelNode.childNode(withName: name, recursively:true)!
            emitter.particleSystem = emitter.node.particleSystems![0]
            emitter.birthRate = emitter.particleSystem.birthRate
            emitter.particleSystem.birthRate = 0
            emitter.node.isHidden = false
            return emitter
        }
        
        fireEmitter = particleEmitterWithName("fire")
        smokeEmitter = particleEmitterWithName("smoke")
        whiteSmokeEmitter = particleEmitterWithName("whiteSmoke")
        
        
        // MARK: Load sound effects
        
        reliefSound = SCNAudioSource(name: "aah_extinction.mp3", volume: 2.0)
        haltFireSound = SCNAudioSource(name: "fire_extinction.mp3", volume: 2.0)
        catchFireSound = SCNAudioSource(name: "ouch_firehit.mp3", volume: 2.0)
        
        for i in 0..<10 {
            if let grassSound = SCNAudioSource(named: "game.scnassets/sounds/Step_grass_0\(i).mp3") {
                grassSound.volume = 0.5
                grassSound.load()
                steps[GroundType.grass.rawValue].append(grassSound)
            }
            
            if let rockSound = SCNAudioSource(named: "game.scnassets/sounds/Step_rock_0\(i).mp3") {
                rockSound.load()
                steps[GroundType.rock.rawValue].append(rockSound)
            }
            
            if let waterSound = SCNAudioSource(named: "game.scnassets/sounds/Step_splash_0\(i).mp3") {
                waterSound.load()
                steps[GroundType.water.rawValue].append(waterSound)
            }
        }
        
        
        // MARK: Configure animations
        
        // Some animations are already there and can be retrieved from the scene
        // The "walk" animation is loaded from a file, it is configured to play foot steps at specific times during the animation
        
        characterTopLevelNode.enumerateChildNodes { (child, _) in
            for key in child.animationKeys {                  // for every animation key
                let animation = child.animation(forKey: key)! // get the animation
                animation.usesSceneTimeBase = false           // make it system time based
                animation.repeatCount = Float.infinity        // make it repeat forever
                child.addAnimation(animation, forKey: key)             // animations are copied upon addition, so we have to replace the previous animation
            }
        }
        
        walkAnimation = CAAnimation.animationWithSceneNamed("game.scnassets/walk.scn")
        walkAnimation.usesSceneTimeBase = false
        walkAnimation.fadeInDuration = 0.3
        walkAnimation.fadeOutDuration = 0.3
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.speed = Character.speedFactor
        walkAnimation.animationEvents = [
            SCNAnimationEvent(keyTime: 0.1) { (_, _, _) in self.playFootStep() },
            SCNAnimationEvent(keyTime: 0.6) { (_, _, _) in self.playFootStep() }]
    }
}
