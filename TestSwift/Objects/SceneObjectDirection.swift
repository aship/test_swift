/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Handles keyboard (OS X), touch (iOS) and controller (iOS, tvOS) input for controlling the game.
*/

import simd
import SceneKit
import GameController

extension SceneObject {

    // MARK: Controller orientation
    
    static let controllerAcceleration = Float(1.0 / 10.0)
    static let controllerDirectionLimit = SIMD2<Float>(repeating: 1.0)
    
    internal func controllerDirection() -> SIMD2<Float> {
        // Poll when using a game controller
        if let dpad = controllerDPad {
            if dpad.xAxis.value == 0.0 && dpad.yAxis.value == 0.0 {
                controllerStoredDirection = SIMD2<Float>(repeating: 0.0)
            } else {
                controllerStoredDirection = clamp(controllerStoredDirection + SIMD2<Float>(dpad.xAxis.value, -dpad.yAxis.value) * SceneObject.controllerAcceleration,
                                                  min: -SceneObject.controllerDirectionLimit,
                                                  max: SceneObject.controllerDirectionLimit)
            }
        }
        
        return controllerStoredDirection
    }
    
    // MARK: Game Controller Events
    
    internal func setupSceneObjects() {
        #if os(OSX)
        gameSCNView.eventsDelegate = self
        #endif
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SceneObject.handleControllerDidConnectNotification(_:)),
                                               name: .GCControllerDidConnect,
                                               object: nil)
    }
    
    @objc func handleControllerDidConnectNotification(_ notification: NSNotification) {
        let sceneObject = notification.object as! GCController
        registerCharacterMovementEvents(sceneObject)
    }
    
    private func registerCharacterMovementEvents(_ sceneObject: GCController) {
        
        // An analog movement handler for D-pads and thumbsticks.
        let movementHandler: GCControllerDirectionPadValueChangedHandler = { [unowned self] dpad, _, _ in
            self.controllerDPad = dpad
        }
        
        // Gamepad D-pad
        if let gamepad = sceneObject.gamepad {
            gamepad.dpad.valueChangedHandler = movementHandler
        }
        
        // Extended gamepad left thumbstick
        if let extendedGamepad = sceneObject.extendedGamepad {
            extendedGamepad.leftThumbstick.valueChangedHandler = movementHandler
        }
    }
}
