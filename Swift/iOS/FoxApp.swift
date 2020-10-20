/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 a standard App Delegate.
 */

import SwiftUI

@main
struct TestSpriteKitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {        
        return WindowGroup {
            ContentView()
        }
    }
}
