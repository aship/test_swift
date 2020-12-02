//
//  GameSKScene.swift
//  TestSwift
//
//  Created by aship on 2020/11/15.
//

import SpriteKit
import SceneKit

class GameSKScene: SKScene {
    var sceneObject: SceneObject?
    
    var collectedFlowerSprites = [SKSpriteNode]()
    let collectedPearlCountLabel = SKLabelNode(fontNamed: "Chalkduster")
    let congratulationsGroupNode = SKNode()
    
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
        
        self.backgroundColor = .clear
        
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
}
