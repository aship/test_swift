//
//  ContentView.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
            SpriteView(scene: GameScene())
                .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
