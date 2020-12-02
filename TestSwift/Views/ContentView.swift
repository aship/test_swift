//
//  ContentView.swift
//  TestSpriteKit
//
//  Created by aship on 2020/10/02.
//

import SwiftUI
import SceneKit
import SpriteKit

struct ContentView: View {
    @StateObject var gameObject = GameObject()
    
    var body: some View {
        ZStack() {
            SceneView(scene: gameObject.scene,
                      pointOfView: gameObject.pointOfView,
                      antialiasingMode: .none,
                      delegate: gameObject)
            
//            Button(action: {
//                print("555555")
//                gameObject.showsStatistics = true
//                gameObject.debugOptions = [.renderAsWireframe,
//                                            .showBoundingBoxes]
//            }) {
//                Text("Debug").padding(.top, 300)
//            }
            SpriteView(scene: gameObject.skScene!,
                       options: [.allowsTransparency])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
