//
//  SceneObject.swift
//  Fox iOS (Swift)
//
//  Created by aship on 2020/11/14.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import SceneKit
import SpriteKit
import GameController

// Collision bit masks
let BitmaskCollision        = Int(1 << 2)
let BitmaskCollectable      = Int(1 << 3)
let BitmaskEnemy            = Int(1 << 4)
let BitmaskSuperCollectable = Int(1 << 5)
let BitmaskWater            = Int(1 << 6)

class SceneObject: NSObject,
                   SCNSceneRendererDelegate,
                   SCNPhysicsContactDelegate,
                   ObservableObject {
    var scnScene = SCNScene(named: "game.scnassets/level.scn")!
    var skScene = GameSKScene()
    
    var pointOfView: SCNNode? = {
        let node = SCNNode()
        node.camera = SCNCamera()
        
        print("node.camera.fieldOfView \(node.camera!.fieldOfView)")
        
        node.camera?.fieldOfView = 26
        
        

        return node
    }()
    
    // Nodes to manipulate the camera
    let cameraYHandle = SCNNode()
    let cameraXHandle = SCNNode()
    
    // The character
    let character = Character()
    
    // Game states
    var gameIsComplete = false
    var lockCamera = false
    
    var grassArea: SCNMaterial!
    var waterArea: SCNMaterial!
    var flames = [SCNNode]()
    var enemies = [SCNNode]()
    
    // Sounds
    var collectPearlSound: SCNAudioSource!
    var collectFlowerSound: SCNAudioSource!
    var flameThrowerSound: SCNAudioPlayer!
    var victoryMusic: SCNAudioSource!
    
    // Particles
    var confettiParticleSystem: SCNParticleSystem!
    var collectFlowerParticleSystem: SCNParticleSystem!
    
    // For automatic camera animation
    var currentGround: SCNNode!
    var mainGround: SCNNode!
    var groundToCameraPosition = [SCNNode: SCNVector3]()
    
    // Game controls
    internal var controllerDPad: GCControllerDirectionPad?
    internal var controllerStoredDirection = SIMD2<Float>(repeating: 0.0) // left/right up/down
    
    var maxPenetrationDistance = CGFloat(0.0)
    var replacementPosition: SCNVector3?
    
    var collectedPearlsCount = 0 {
        didSet {
            self.skScene.collectedPearlsCount = collectedPearlsCount
        }
    }
    
    var collectedFlowersCount = 0 {
        didSet {
            self.skScene.collectedFlowersCount = collectedFlowersCount
            
            if (collectedFlowersCount == 3) {
                showEndScreen()
            }
        }
    }
    
    internal var padTouch: UITouch?
    internal var panningTouch: UITouch?
    
    override init() {
        super.init()
                
        self.skScene.sceneObject = self
        scnScene.physicsWorld.contactDelegate = self
        


        // Various setup
        setupCamera()
        
        setupEtc()
        
        setupAutomaticCameraPositions()
        setupSceneObjects()
        
        setupSounds()
        setupBgm()
        
        // print("self.rootNode.position  \(self.scnScene.rootNode.position)")
        // print("pointOfView.position  \(self.pointOfView!.position)")
        
    }
}
