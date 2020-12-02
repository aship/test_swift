/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The OS X implementation of the application delegate of the game.
*/

#import "AAPLAppDelegate.h"

@implementation AAPLAppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(nonnull NSApplication *)sender {
    return YES;
}

@end
