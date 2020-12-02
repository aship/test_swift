//
//  GameSKScene.swift
//  TestSwift
//
//  Created by aship on 2020/11/15.
//

import SpriteKit
import SceneKit

class GameSKScene: SKScene {
    var gameSCNView: GameSCNView?
    
    private var collectedFlowerSprites = [SKSpriteNode]()
    private let collectedPearlCountLabel = SKLabelNode(fontNamed: "Chalkduster")
    private let congratulationsGroupNode = SKNode()
    
    var collectedPearlsCount = 0 {
        didSet {
            if collectedPearlsCount == 10 {
                collectedPearlCountLabel.position = CGPoint(x: 158,
                                                            y: collectedPearlCountLabel.position.y)
            }
            collectedPearlCountLabel.text = "x\(collectedPearlsCount)"
        }
    }
    
    var collectedFlowersCount = 0 {
        didSet {
            collectedFlowerSprites[collectedFlowersCount - 1].texture = SKTexture(imageNamed: "FlowerFull.png")
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        print("#### GameSKScene didMove")
        
        //   let w = screenWidth
        // let h = screenHeight
        let h = screenHeight
        
        //  print("XXXXX w \(w)  h \(h)")
        
        // Setup the game overlays using SpriteKit.
        //   let skScene = GameSKScene(size: CGSize(width: w,
        //                                         height: h))
        
        self.scaleMode = .resizeFill
        
        
        
        
        let overlayNode = SKNode()
        overlayNode.position = CGPoint(x: 0.0,
                                       y: h)
        
        
        self.addChild(overlayNode)
        overlayNode.position = CGPoint(x: 0.0,
                                       y: h)
        
        // The Max icon.
        overlayNode.addChild(SKSpriteNode(imageNamed: "MaxIcon.png",
                                          position: CGPoint(x: 50,
                                                            y: -50),
                                          scale: 0.5))
        
        // The flowers.
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "FlowerEmpty.png",
                                          position: CGPoint(x: 110 + i * 40,
                                                            y: -50),
                                          scale: 0.25)
            collectedFlowerSprites.append(spriteNode)
            overlayNode.addChild(collectedFlowerSprites[i])
        }
        
        // The pearl icon and count.
        overlayNode.addChild(SKSpriteNode(imageNamed: "ItemsPearl.png",
                                          position: CGPoint(x: 110, y: -100),
                                          scale: 0.5))
        
        collectedPearlCountLabel.text = "x0"
        collectedPearlCountLabel.position = CGPoint(x: 152,
                                                    y: -113)
        overlayNode.addChild(collectedPearlCountLabel)
        
        // The virtual D-pad
        
        let virtualDPadBounds = virtualDPadBoundsInScene()
        let dpadSprite = SKSpriteNode(imageNamed: "dpad.png",
                                      position: virtualDPadBounds.origin, scale: 1.0)
        dpadSprite.anchorPoint = CGPoint(x: 0.0,
                                         y: 0.0)
        dpadSprite.size = virtualDPadBounds.size
        self.addChild(dpadSprite)
        
        self.isUserInteractionEnabled = true
    }
    
    // MARK: Virtual D-pad
    private func virtualDPadBoundsInScene() -> CGRect {
        return CGRect(x: 10.0,
                      y: 10.0,
                      width: 150.0,
                      height: 150.0)
    }
    
    func virtualDPadBounds() -> CGRect {
        
        var virtualDPadBounds = virtualDPadBoundsInScene()
        virtualDPadBounds.origin.y = screenHeight - virtualDPadBounds.size.height + virtualDPadBounds.origin.y
        return virtualDPadBounds
    }
    
    
    // MARK: Congratulating the Player
    
    func showEndScreen() {
        // Congratulation title
        let congratulationsNode = SKSpriteNode(imageNamed: "congratulations.png")
        
        // Max image
        let characterNode = SKSpriteNode(imageNamed: "congratulations_pandaMax.png")
        characterNode.position = CGPoint(x: 0.0, y: -220.0)
        characterNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        congratulationsGroupNode.addChild(characterNode)
        congratulationsGroupNode.addChild(congratulationsNode)
        
        //    let overlayScene = overlaySKScene!
        self.addChild(congratulationsGroupNode)
        
        // Layout the overlay
        layout2DOverlay()
        
        // Animate
        (congratulationsNode.alpha,
         congratulationsNode.xScale,
         congratulationsNode.yScale) = (0.0, 0.0, 0.0)
        congratulationsNode.run(SKAction.group([SKAction.fadeIn(withDuration: 0.25),
                                                SKAction.sequence([SKAction.scale(to: 1.22,
                                                                                  duration: 0.25),
                                                                   SKAction.scale(to: 1.0,
                                                                                  duration: 0.1)])]))
        
        (characterNode.alpha,
         characterNode.xScale,
         characterNode.yScale) = (0.0, 0.0, 0.0)
        characterNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                             SKAction.group([SKAction.fadeIn(withDuration: 0.5),
                                                             SKAction.sequence([SKAction.scale(to: 1.22,
                                                                                               duration: 0.25),
                                                                                SKAction.scale(to: 1.0,
                                                                                               duration: 0.1)])])]))
        
        congratulationsGroupNode.position = CGPoint(x: screenWidth * 0.5,
                                                    y: screenHeight * 0.5);
    }
    
    
    private func layout2DOverlay() {
        let bounds = CGRect(x: 0,
                            y: 0,
                            width: screenWidth,
                            height: screenHeight)
        
        congratulationsGroupNode.position = CGPoint(x: screenWidth * 0.5,
                                                    y: screenHeight * 0.5)
        
        congratulationsGroupNode.xScale = 1.0
        congratulationsGroupNode.yScale = 1.0
        let currentBbox = congratulationsGroupNode.calculateAccumulatedFrame()
        
        let margin = CGFloat(25.0)
        let maximumAllowedBbox = bounds.insetBy(dx: margin, dy: margin)
        
        let top = currentBbox.maxY - congratulationsGroupNode.position.y
        let bottom = congratulationsGroupNode.position.y - currentBbox.minY
        let maxTopAllowed = maximumAllowedBbox.maxY - congratulationsGroupNode.position.y
        let maxBottomAllowed = congratulationsGroupNode.position.y - maximumAllowedBbox.minY
        
        let left = congratulationsGroupNode.position.x - currentBbox.minX
        let right = currentBbox.maxX - congratulationsGroupNode.position.x
        let maxLeftAllowed = congratulationsGroupNode.position.x - maximumAllowedBbox.minX
        let maxRightAllowed = maximumAllowedBbox.maxX - congratulationsGroupNode.position.x
        
        let topScale = top > maxTopAllowed ? maxTopAllowed / top : 1
        let bottomScale = bottom > maxBottomAllowed ? maxBottomAllowed / bottom : 1
        let leftScale = left > maxLeftAllowed ? maxLeftAllowed / left : 1
        let rightScale = right > maxRightAllowed ? maxRightAllowed / right : 1
        
        let scale = min(topScale, min(bottomScale, min(leftScale, rightScale)))
        
        congratulationsGroupNode.xScale = scale
        congratulationsGroupNode.yScale = scale
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        
        
        let sceneObject = gameSCNView!.sceneObject!
        
        for touch in touches {
            if self.virtualDPadBounds()
                .contains(touch.location(in: gameSCNView!)) {
                print("TOUCHESS BEGIN PAD")
                
                // We're in the dpad
                if sceneObject.padTouch == nil {
                    sceneObject.padTouch = touch
                    sceneObject.controllerStoredDirection = SIMD2<Float>(repeating: 0.0)
                }
            } else if sceneObject.panningTouch == nil {
                print("TOUCHESS BEGIN PANNING")
                
                // Start panning
                sceneObject.panningTouch = touches.first
            }
            
            if sceneObject.padTouch != nil && sceneObject.panningTouch != nil {
                break // We already have what we need
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //  print("TOUCHESS ")
        
        let sceneObject = gameSCNView!.sceneObject!
        
        
        if let touch = sceneObject.panningTouch {
            
            print("PANNING MOVED")
            
            let pointPrevious: CGPoint = touch.previousLocation(in: gameSCNView)
            let locationPrevious = SIMD2<Float>(Float(pointPrevious.x), Float(pointPrevious.y))
            
            let point: CGPoint = touch.location(in: gameSCNView)
            let location = SIMD2<Float>(Float(point.x), Float(point.y))
            
            let displacement = location - locationPrevious
            
            //      let displacement = (SIMD2<Float>(touch.location(in: gameSCNView)) - SIMD2<Float>(touch.previousLocation(in: gameSCNView)))
            
            sceneObject.panCamera(displacement)
            
            
            
        }
        
        if let touch = sceneObject.padTouch {
            
            print("PAD  MOVED")
            //      let displacement = (SIMD2<Float>(touch.location(in: view)) - SIMD2<Float>(touch.previousLocation(in: view)))
            
            let pointPrevious: CGPoint = touch.previousLocation(in: gameSCNView)
            let locationPrevious = SIMD2<Float>(Float(pointPrevious.x), Float(pointPrevious.y))
            
            let point: CGPoint = touch.location(in: gameSCNView)
            let location = SIMD2<Float>(Float(point.x), Float(point.y))
            
            let displacement = location - locationPrevious
            
            
            sceneObject.controllerStoredDirection = clamp(mix(sceneObject.controllerStoredDirection,
                                                              displacement,
                                                              t: SceneObject.controllerAcceleration),
                                                          min: -SceneObject.controllerDirectionLimit,
                                                          max: SceneObject.controllerDirectionLimit)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        commonTouchesEnded(touches, withEvent: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        commonTouchesEnded(touches, withEvent: event)
    }
    
    func commonTouchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        let sceneObject = gameSCNView!.sceneObject!
        
        if let touch = sceneObject.panningTouch {
            print("PANNIG END")
            
            if touches.contains(touch) {
                sceneObject.panningTouch = nil
            }
        }
        
        if let touch = sceneObject.padTouch {
            if sceneObject.padTouch != nil {
                
                print("PAD  ENDD")
                
                if touches.contains(touch) || event?.touches(for: view!)!.contains(touch) == false {
                    sceneObject.padTouch = nil
                    sceneObject.controllerStoredDirection = SIMD2<Float>(repeating: 0.0)
                }
            }
        }
    }
}
