//
//  CharacterNode.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension Character {
    func loadCharacter() {
        /// Load character from external file
        let scene = SCNScene( named: "Art.scnassets/character/max.scn")!
        model = scene.rootNode.childNode( withName: "Max_rootNode", recursively: true)
        model.simdPosition = Character.modelOffset
        
        /* setup character hierarchy
         character
         |_orientationNode
         |_model
         */
        characterNode = SCNNode()
        characterNode.name = "character"
        characterNode.simdPosition = Character.initialPosition
        
        characterOrientation = SCNNode()
        characterNode.addChildNode(characterOrientation)
        characterOrientation.addChildNode(model)
        
        let collider = model.childNode(withName: "collider", recursively: true)!
        collider.physicsBody?.collisionBitMask = Int(([ .enemy, .trigger, .collectable ] as Bitmask).rawValue)
        
        // Setup collision shape
        let (min, max) = model.boundingBox
        let collisionCapsuleRadius = CGFloat(max.x - min.x) * CGFloat(0.4)
        let collisionCapsuleHeight = CGFloat(max.y - min.y)
        
        let collisionGeometry = SCNCapsule(capRadius: collisionCapsuleRadius, height: collisionCapsuleHeight)
        characterCollisionShape = SCNPhysicsShape(geometry: collisionGeometry, options:[.collisionMargin: Character.collisionMargin])
        collisionShapeOffsetFromModel = SIMD3<Float>(0, Float(collisionCapsuleHeight) * 0.51, 0.0)
    }
    
    func loadParticles() {
        var particleScene = SCNScene( named: "Art.scnassets/character/jump_dust.scn")!
        let particleNode = particleScene.rootNode.childNode(withName: "particle", recursively: true)!
        jumpDustParticle = particleNode.particleSystems!.first!
        
        particleScene = SCNScene( named: "Art.scnassets/particles/burn.scn")!
        let burnParticleNode = particleScene.rootNode.childNode(withName: "particles", recursively: true)!
        
        let particleEmitter = SCNNode()
        characterOrientation.addChildNode(particleEmitter)
        
        fireEmitter = burnParticleNode.childNode(withName: "fire", recursively: true)!.particleSystems![0]
        fireEmitterBirthRate = fireEmitter.birthRate
        fireEmitter.birthRate = 0
        
        smokeEmitter = burnParticleNode.childNode(withName: "smoke", recursively: true)!.particleSystems![0]
        smokeEmitterBirthRate = smokeEmitter.birthRate
        smokeEmitter.birthRate = 0
        
        whiteSmokeEmitter = burnParticleNode.childNode(withName: "whiteSmoke", recursively: true)!.particleSystems![0]
        whiteSmokeEmitterBirthRate = whiteSmokeEmitter.birthRate
        whiteSmokeEmitter.birthRate = 0
        
        particleScene = SCNScene(named:"Art.scnassets/particles/particles_spin.scn")!
        spinParticle = (particleScene.rootNode.childNode(withName: "particles_spin", recursively: true)?.particleSystems?.first!)!
        spinCircleParticle = (particleScene.rootNode.childNode(withName: "particles_spin_circle", recursively: true)?.particleSystems?.first!)!
        
        particleEmitter.position = SCNVector3Make(0, 0.05, 0)
        particleEmitter.addParticleSystem(fireEmitter)
        particleEmitter.addParticleSystem(smokeEmitter)
        particleEmitter.addParticleSystem(whiteSmokeEmitter)
        
        spinParticleAttach = model.childNode(withName: "particles_spin_circle", recursively: true)
    }
    
    func loadSounds() {
        aahSound = SCNAudioSource( named: "audio/aah_extinction.mp3")!
        aahSound.volume = 1.0
        aahSound.isPositional = false
        aahSound.load()
        
        catchFireSound = SCNAudioSource(named: "audio/panda_catch_fire.mp3")!
        catchFireSound.volume = 5.0
        catchFireSound.isPositional = false
        catchFireSound.load()
        
        ouchSound = SCNAudioSource(named: "audio/ouch_firehit.mp3")!
        ouchSound.volume = 2.0
        ouchSound.isPositional = false
        ouchSound.load()
        
        hitSound = SCNAudioSource(named: "audio/hit.mp3")!
        hitSound.volume = 2.0
        hitSound.isPositional = false
        hitSound.load()
        
        hitEnemySound = SCNAudioSource(named: "audio/Explosion1.m4a")!
        hitEnemySound.volume = 2.0
        hitEnemySound.isPositional = false
        hitEnemySound.load()
        
        explodeEnemySound = SCNAudioSource(named: "audio/Explosion2.m4a")!
        explodeEnemySound.volume = 2.0
        explodeEnemySound.isPositional = false
        explodeEnemySound.load()
        
        jumpSound = SCNAudioSource(named: "audio/jump.m4a")!
        jumpSound.volume = 0.2
        jumpSound.isPositional = false
        jumpSound.load()
        
        attackSound = SCNAudioSource(named: "audio/attack.mp3")!
        attackSound.volume = 1.0
        attackSound.isPositional = false
        attackSound.load()
        
        for i in 0..<Character.stepsCount {
            steps[i] = SCNAudioSource(named: "audio/Step_rock_0\(UInt32(i)).mp3")!
            steps[i].volume = 0.5
            steps[i].isPositional = false
            steps[i].load()
        }
    }
        
    func queueResetCharacterPosition() {
        shouldResetCharacterPosition = true
    }
}
