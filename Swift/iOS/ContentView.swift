//
//  ContentView.swift
//  fox2-swift iOS
//
//  Created by aship on 2020/10/20.
//  Copyright © 2020 com.apple. All rights reserved.
//

import SwiftUI
import SceneKit

struct ContentView: UIViewRepresentable {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
  //  @Environment(\.gameController) private var gameController: GameController
    
    var scene = SCNScene()
    
  //  @EnvironmentObject var gameController: GameController
    
 //   var gameController = GameController(scnView: SCNView())
    
    class Coordinator: NSObject {
        //      var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.backgroundColor = UIColor.blue
        

        
        
        // 1.3x on iPads
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            self.gameView.contentScaleFactor = min(1.3, self.gameView.contentScaleFactor)
//            self.gameView.preferredFramesPerSecond = 60
//        }
//        
        appDelegate.gameController = GameController(scnView: scnView)

        // Configure the view
   //     gameView.backgroundColor = UIColor.black
        
        
        return scnView
    }
    
    func updateUIView(_ view: SCNView, context: Context) {
        //      view.presentScene(context.coordinator.scene)
    }
}
