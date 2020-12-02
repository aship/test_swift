//
//  GameObject.swift
//  TestSwift
//
//  Created by aship on 2020/11/29.
//

import SceneKit
import SpriteKit
import GameController
import GameplayKit

class GameObject: NSObject,
                  SCNSceneRendererDelegate,
                  SCNPhysicsContactDelegate,
                  MenuDelegate,
                  PadOverlayDelegate,
                  ButtonOverlayDelegate,
                  ObservableObject {
    var pointOfView: SCNNode!
    var foxNode: SCNNode!
    
    // Global settings
    static let DefaultCameraTransitionDuration = 1.0
    static let NumberOfFiends = 100
    static let CameraOrientationSensitivity: Float = 0.05
    
    
    // Camera and targets
    var cameraNode = SCNNode()
    var lookAtTarget = SCNNode()
    var lastActiveCamera: SCNNode?
    var lastActiveCameraFrontDirection = simd_float3.zero
    var activeCamera: SCNNode?
    var playingCinematic: Bool = false
    
    // Character
    var character: Character?
    
    var showsStatistics: Bool = false
    var debugOptions: SCNDebugOptions = []
    
    let initialPosition = SIMD3<Float>(0.1, -0.2, 0)
    
    var scene = SCNScene(named: "Art.scnassets/scene.scn")!
    
    // triggers
    var lastTrigger: SCNNode?
    var firstTriggerDone: Bool = false
    
    // enemies
    var enemy1: SCNNode?
    var enemy2: SCNNode?
    
    // friends
    var friends = [SCNNode](repeating: SCNNode(), count: NumberOfFiends)
    var friendsSpeed = [Float](repeating: 0.0, count: NumberOfFiends)
    var friendCount: Int = 0
    var friendsAreFree: Bool = false
    
    // collected objects
    var collectedKeys: Int = 0
    var collectedGems: Int = 0
    var keyIsVisible: Bool = false
    
    // Overlays
  //  var overlay: OverlaySKScene?
    
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
    
    var skScene: OverlaySKScene?
    
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
    
    override init() {
        super.init()
        
        print("GEMEOBJECT  INITTTT")
        
        
        self.skScene = OverlaySKScene(size: CGSize(width: 10.0,
                                                   height: 10.0))
        self.skScene!.gameObject = self
        self.skScene!.backgroundColor = .clear
     //   self.skScene!.view?.isMultipleTouchEnabled = true
            
      

        setupPhysics()
        setupCollisions()
        
        setupCharacter()
        setupEnemies()
        
        addFriends(3)
        setupPlatforms()
        setupParticleSystem()
        
        //setup lighting
        let light = scene.rootNode.childNode(withName: "DirectLight",
                                              recursively: true)!.light
        light!.shadowCascadeCount = 3  // turn on cascade shadows
        light!.shadowMapSize = CGSize(width: CGFloat(512), height: CGFloat(512))
        light!.maximumShadowDistance = 20
        light!.shadowCascadeSplittingFactor = 0.5
        
        
        setupCamera()
        setupGameObject()
        setupAudio()
        
        self.pointOfView = self.cameraNode
        
        self.scene.physicsWorld.contactDelegate = self
    }
    
    //    func addFox() {
    //        let scene = SCNScene(named: "Art.scnassets/character/max.scn")!
    //
    //        self.foxNode = scene.rootNode.childNodes[0]
    //
    ////        childNode.scale = SCNVector3(x: 10.0,
    ////                                     y: 10.0,
    ////                                     z: 10.0)
    //
    //        self.foxNode.simdPosition = self.initialPosition
    //
    //      //      SCNVector3(x: 0.0,
    //        //                                y: 0.0,
    //          //                              z: 0.0)
    //        
    //        self.scene.rootNode.addChildNode(self.foxNode)
    //    }
    
    //    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    //        // print("3333333")
    //
    //        renderer.showsStatistics = self.showsStatistics
    //        renderer.debugOptions = self.debugOptions
    //    }
}
