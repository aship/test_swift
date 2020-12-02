/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The view displaying the game scene, including the 2D overlay.
 */

import simd
import SceneKit
import SpriteKit

class GameSCNView: SCNView {
    var sceneObject: SceneObject?
    
    // MARK: 2D Overlay
    
  //  private let overlayNode = SKNode()
 

    
    
    init() {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: 100,
                                 height: 100),
                   options: nil)
        
        print("INITTTTTT")
        
        let skScene = GameSKScene()
        skScene.gameSCNView = self
        
        // Assign the SpriteKit overlay to the SceneKit view.
        overlaySKScene = skScene
        
        
    //    layout2DOverlay()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


 
        

}
