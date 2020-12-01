//
//  GameObjectEtc2.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    
    // MARK: - Triggers
    
    // "triggers" are triggered when a character enter a box with the collision mask BitmaskTrigger
    func execTrigger(_ triggerNode: SCNNode, animationDuration duration: CFTimeInterval) {
        //exec trigger
        if triggerNode.name!.hasPrefix("trigCam_") {
            let cameraName = (triggerNode.name as NSString?)!.substring(from: 8)
            setActiveCamera(cameraName, animationDuration: duration)
        }
        //action
        if triggerNode.name!.hasPrefix("trigAction_") {
            if collectedKeys > 0 {
                let actionName = (triggerNode.name as NSString?)!.substring(from: 11)
                if actionName == "unlockDoor" {
                    unlockDoor()
                }
            }
        }
    }
    
    func trigger(_ triggerNode: SCNNode) {
        if playingCinematic {
            return
        }
        if lastTrigger != triggerNode {
            lastTrigger = triggerNode
            
            // the very first trigger should not animate (initial camera position)
            execTrigger(triggerNode, animationDuration: firstTriggerDone ? GameObject.DefaultCameraTransitionDuration: 0)
            firstTriggerDone = true
        }
    }
    

    
    // MARK: - Congratulating the Player
    
    func showEndScreen() {
        // Play the congrat sound.
        guard let victoryMusic = SCNAudioSource(named: "audio/Music_victory.mp3") else { return }
        victoryMusic.volume = 0.5
        
        self.scene?.rootNode.addAudioPlayer(SCNAudioPlayer(source: victoryMusic))
        
        self.overlay?.showEndScreen()
    }
    
    // MARK: - Debug menu
    
    func fStopChanged(_ value: CGFloat) {
        sceneRenderer!.pointOfView!.camera!.fStop = value
    }
    
    func focusDistanceChanged(_ value: CGFloat) {
        sceneRenderer!.pointOfView!.camera!.focusDistance = value
    }
    
    func debugMenuSelectCameraAtIndex(_ index: Int) {
        if index == 0 {
            let key = self.scene?.rootNode .childNode(withName: "key", recursively: true)
            key?.opacity = 1.0
        }
        self.setActiveCamera("CameraDof\(index)")
    }
}
