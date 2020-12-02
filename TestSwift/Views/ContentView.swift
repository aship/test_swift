//
//  ContentView.swift
//  Fox iOS (Swift)
//
//  Created by aship on 2020/11/14.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import SwiftUI
import SceneKit

struct ContentView: UIViewRepresentable {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //  @Environment(\.sceneObject) private var sceneObject: SceneObject
    
    // var scene = SCNScene()
    
    //  @EnvironmentObject var sceneObject: SceneObject
    
    //   var sceneObject = SceneObject(scnView: SCNView())
    
    class Coordinator: NSObject {
        //      var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SCNView {
        let gameSCNView = GameSCNView()
        //        scnView.scene = scene
        //        scnView.backgroundColor = UIColor.blue
        //
        
        appDelegate.sceneObject = SceneObject(scnView: gameSCNView)
        

        
        
        
        // 1.3x on iPads
        //        if UIDevice.current.userInterfaceIdiom == .pad {
        //            self.gameSCNView.contentScaleFactor = min(1.3, self.gameSCNView.contentScaleFactor)
        //            self.gameSCNView.preferredFramesPerSecond = 60
        //        }
        //
        //    appDelegate.sceneObject = SceneObject(scnView: scnView)
        
        // Configure the view
        //     gameSCNView.backgroundColor = UIColor.black
        
        
        return gameSCNView
    }
    
    func updateUIView(_ view: SCNView, context: Context) {
        //      view.presentScene(context.coordinator.scene)
    }
}
