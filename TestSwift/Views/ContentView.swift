//
//  ContentView.swift
//  Fox iOS (Swift)
//
//  Created by aship on 2020/11/14.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import SwiftUI
import SceneKit
import SpriteKit

struct ContentView: View {
    @StateObject var sceneObject = SceneObject()
    
    var body: some View {
        ZStack() {
            SceneView(scene: sceneObject.scnScene,
                      pointOfView: sceneObject.pointOfView,
                      options: [.rendersContinuously],
                      delegate: sceneObject)
            
            SpriteView(scene: sceneObject.skScene,
                       options: [.allowsTransparency])
        }
    }
}
