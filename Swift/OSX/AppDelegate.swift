/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The OS X implementation of the application delegate of the game.
*/

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    private func applicationShouldTerminate(afterLastWindowClosed sender: NSApplication) -> Bool {
        return true
    }
    
}
