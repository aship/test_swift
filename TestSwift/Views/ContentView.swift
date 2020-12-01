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
    
    class Coordinator: NSObject {
        //      var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = UIColor.blue
    
        appDelegate.GameObject = GameObject(scnView: scnView)

        return scnView
    }
    
    func updateUIView(_ view: SCNView, context: Context) {
    }
}
