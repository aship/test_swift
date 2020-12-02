//
//  GameObjectUpdate.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

import SceneKit
import GameplayKit

extension GameObject {
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
        if self.skScene!.controlOverlay!.isHidden == true {
            print("VIRTUAL PAD ON")
            self.skScene!.showVirtualPad()
        }

        // compute delta time
        if lastUpdateTime == 0 {
            lastUpdateTime = time
        }
        
        let deltaTime: TimeInterval = time - lastUpdateTime
        lastUpdateTime = time
        
        // Update Friends
        if friendsAreFree {
            updateFriends(deltaTime: deltaTime)
        }
        
        // stop here if cinematic
        if playingCinematic == true {
            return
        }
        
        // update characters
        character!.update(atTime: time, with: renderer)
        
        // update enemies
        for entity: GKEntity in gkScene!.entities {
            entity.update(deltaTime: deltaTime)
        }
    }
}
