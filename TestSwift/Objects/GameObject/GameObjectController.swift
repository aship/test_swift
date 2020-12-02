//
//  GameObjectController.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

import GameController
import GameplayKit
import SceneKit

extension GameObject {
    // MARK: - GameObject
    
    @objc
    func handleControllerDidConnect(_ notification: Notification) {
        if gamePadCurrent != nil {
            return
        }
        guard let GameObject = notification.object as? GCController else {
            return
        }
        registerGameObject(GameObject)
    }
    
    @objc
    func handleControllerDidDisconnect(_ notification: Notification) {
        guard let GameObject = notification.object as? GCController else {
            return
        }
        if GameObject != gamePadCurrent {
            return
        }
        
        unregisterGameObject()
        
        for controller: GCController in GCController.controllers() where GameObject != controller {
            registerGameObject(controller)
        }
    }
    
    func registerGameObject(_ GameObject: GCController) {
        
        var buttonA: GCControllerButtonInput?
        var buttonB: GCControllerButtonInput?
        
        if let gamepad = GameObject.extendedGamepad {
            self.gamePadLeft = gamepad.leftThumbstick
            self.gamePadRight = gamepad.rightThumbstick
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonB
        } else if let gamepad = GameObject.microGamepad {
            self.gamePadLeft = gamepad.dpad
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonX
        }
        
        weak var weakController = self
        
        gamePadLeft!.valueChangedHandler = {(_ dpad: GCControllerDirectionPad, _ xValue: Float, _ yValue: Float) -> Void in
            guard let strongController = weakController else {
                return
            }
            strongController.characterDirection = simd_make_float2(xValue, -yValue)
        }
        
        if let gamePadRight = self.gamePadRight {
            gamePadRight.valueChangedHandler = {(_ dpad: GCControllerDirectionPad, _ xValue: Float, _ yValue: Float) -> Void in
                guard let strongController = weakController else {
                    return
                }
                strongController.cameraDirection = simd_make_float2(xValue, yValue)
            }
        }
        
        buttonA?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongController = weakController else {
                return
            }
            strongController.controllerJump(pressed)
        }
        
        buttonB?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongController = weakController else {
                return
            }
            strongController.controllerAttack()
        }
        
        #if os( iOS )
        if gamePadLeft != nil {
            self.skScene!.hideVirtualPad()
        }
        #endif
    }
    
    func unregisterGameObject() {
        gamePadLeft = nil
        gamePadRight = nil
        gamePadCurrent = nil
        #if os( iOS )
        self.skScene!.showVirtualPad()
        #endif
    }
}
