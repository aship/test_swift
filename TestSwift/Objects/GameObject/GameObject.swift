/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class serves as the app's source of control flow.
 */

import GameController
import GameplayKit
import SceneKit

// Collision bit masks
struct Bitmask: OptionSet {
    let rawValue: Int
    static let character = Bitmask(rawValue: 1 << 0) // the main character
    static let collision = Bitmask(rawValue: 1 << 1) // the ground and walls
    static let enemy = Bitmask(rawValue: 1 << 2) // the enemies
    static let trigger = Bitmask(rawValue: 1 << 3) // the box that triggers camera changes and other actions
    static let collectable = Bitmask(rawValue: 1 << 4) // the collectables (gems and key)
}

#if os( iOS )
typealias ExtraProtocols = SCNSceneRendererDelegate & SCNPhysicsContactDelegate & MenuDelegate
    & PadOverlayDelegate & ButtonOverlayDelegate
#else
typealias ExtraProtocols = SCNSceneRendererDelegate & SCNPhysicsContactDelegate & MenuDelegate
#endif

enum ParticleKind: Int {
    case collect = 0
    case collectBig
    case keyApparition
    case enemyExplosion
    case unlockDoor
    case totalCount
}

enum AudioSourceKind: Int {
    case collect = 0
    case collectBig
    case unlockDoor
    case hitEnemy
    case totalCount
}

class GameObject: NSObject, ExtraProtocols {
    
    // Global settings
    static let DefaultCameraTransitionDuration = 1.0
    static let NumberOfFiends = 100
    static let CameraOrientationSensitivity: Float = 0.05
    
    var scene = SCNScene(named: "Art.scnassets/scene.scn")
    weak var sceneRenderer: SCNSceneRenderer?
    
    // Overlays
    var overlay: OverlaySKScene?
    
    // Character
    var character: Character?
    
    // Camera and targets
    var cameraNode = SCNNode()
    var lookAtTarget = SCNNode()
    var lastActiveCamera: SCNNode?
    var lastActiveCameraFrontDirection = simd_float3.zero
    var activeCamera: SCNNode?
    var playingCinematic: Bool = false
    
    //triggers
    var lastTrigger: SCNNode?
    var firstTriggerDone: Bool = false
    
    //enemies
    var enemy1: SCNNode?
    var enemy2: SCNNode?
    
    //friends
    var friends = [SCNNode](repeating: SCNNode(), count: NumberOfFiends)
    var friendsSpeed = [Float](repeating: 0.0, count: NumberOfFiends)
    var friendCount: Int = 0
    var friendsAreFree: Bool = false
    
    //collected objects
    var collectedKeys: Int = 0
    var collectedGems: Int = 0
    var keyIsVisible: Bool = false
    
    // particles
    var particleSystems = [[SCNParticleSystem]](repeatElement([SCNParticleSystem()], count: ParticleKind.totalCount.rawValue))
    
    // audio
    var audioSources = [SCNAudioSource](repeatElement(SCNAudioSource(), count: AudioSourceKind.totalCount.rawValue))
    
    // GameplayKit
    var gkScene: GKScene?
    
    // Game controller
    var gamePadCurrent: GCController?
    var gamePadLeft: GCControllerDirectionPad?
    var gamePadRight: GCControllerDirectionPad?
    
    // update delta time
    var lastUpdateTime = TimeInterval()
    
    var characterDirection: vector_float2 {
        get {
            return character!.direction
        }
        set {
            var direction = newValue
            let l = simd_length(direction)
            if l > 1.0 {
                direction *= 1 / l
            }
            character!.direction = direction
        }
    }
    
    var cameraDirection = vector_float2.zero {
        didSet {
            let l = simd_length(cameraDirection)
            if l > 1.0 {
                cameraDirection *= 1 / l
            }
            cameraDirection.y = 0
        }
    }
    
    init(scnView: SCNView) {
        super.init()
        
        sceneRenderer = scnView
        sceneRenderer!.delegate = self
        
        // Uncomment to show statistics such as fps and timing information
        //scnView.showsStatistics = true
        
        // setup overlay
        overlay = OverlaySKScene(size: scnView.bounds.size,
                                 gameObject: self)
        scnView.overlaySKScene = overlay
        
        //setup physics
        setupPhysics()
        
        //setup collisions
        setupCollisions()
        
        //load the character
        setupCharacter()
        
        //setup enemies
        setupEnemies()
        
        //setup friends
        addFriends(3)
        
        //setup platforms
        setupPlatforms()
        
        //setup particles
        setupParticleSystem()
        
        //setup lighting
        let light = scene!.rootNode.childNode(withName: "DirectLight",
                                              recursively: true)!.light
        light!.shadowCascadeCount = 3  // turn on cascade shadows
        light!.shadowMapSize = CGSize(width: CGFloat(512), height: CGFloat(512))
        light!.maximumShadowDistance = 20
        light!.shadowCascadeSplittingFactor = 0.5
        
        //setup camera
        setupCamera()
        
        //setup game controller
        setupGameObject()
        
        //configure quality
        configureRenderingQuality(scnView)
        
        //assign the scene to the view
        sceneRenderer!.scene = self.scene
        
        //setup audio
        setupAudio()
        
        //select the point of view to use
        sceneRenderer!.pointOfView = self.cameraNode
        
        //register ourself as the physics contact delegate to receive contact notifications
        sceneRenderer!.scene!.physicsWorld.contactDelegate = self
    }
}
