//
//  GameObjectAction.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

import GameplayKit
import SceneKit

extension GameObject {
    // MARK: - Game actions
    
    func unlockDoor() {
        if friendsAreFree {  //already unlocked
            return
        }
        
        startCinematic()  //pause the scene
        
        //play sound
        playSound(AudioSourceKind.unlockDoor)
        
        //cinematic02
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        SCNTransaction.completionBlock = {() -> Void in
            //trigger particles
            let door: SCNNode? = self.scene!.rootNode.childNode(withName: "door", recursively: true)
            let particle_door: SCNNode? = self.scene!.rootNode.childNode(withName: "particles_door", recursively: true)
            self.addParticles(with: .unlockDoor, withTransform: particle_door!.worldTransform)
            
            //audio
            self.playSound(.collectBig)
            
            //add friends
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.0
            self.addFriends(GameObject.NumberOfFiends)
            SCNTransaction.commit()
            
            //open the door
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.0
            SCNTransaction.completionBlock = {() -> Void in
                //animate characters
                self.animateFriends()
                
                // update state
                self.friendsAreFree = true
                
                // show end screen
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
                                                Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                                                    self.showEndScreen()
                                                })
            }
            door!.opacity = 0.0
            SCNTransaction.commit()
        }
        
        // change the point of view
        setActiveCamera("CameraCinematic02", animationDuration: 1.0)
        SCNTransaction.commit()
    }
    
    func showKey() {
        keyIsVisible = true
        
        // get the key node
        let key: SCNNode? = scene!.rootNode.childNode(withName: "key", recursively: true)
        
        //sound fx
        playSound(AudioSourceKind.collectBig)
        
        //particles
        addParticles(with: .keyApparition, withTransform: key!.worldTransform)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        SCNTransaction.completionBlock = {() -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
                                            Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                                                self.keyDidAppear()
                                            })
        }
        key!.opacity = 1.0 // show the key
        SCNTransaction.commit()
    }
    
    func keyDidAppear() {
        execTrigger(lastTrigger!, animationDuration: 0.75) //revert to previous camera
        stopCinematic()
    }
    
    func keyShouldAppear() {
        startCinematic()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        SCNTransaction.completionBlock = {() -> Void in
            self.showKey()
        }
        setActiveCamera("CameraCinematic01", animationDuration: 3.0)
        SCNTransaction.commit()
    }
    
    func collect(_ collectable: SCNNode) {
        if collectable.physicsBody != nil {
            
            //the Key
            if collectable.name == "key" {
                if !self.keyIsVisible { //key not visible yet
                    return
                }
                
                // play sound
                playSound(AudioSourceKind.collect)
                self.overlay?.didCollectKey()
                
                self.collectedKeys += 1
            }
            
            //the gems
            else if collectable.name == "CollectableBig" {
                self.collectedGems += 1
                
                // play sound
                playSound(AudioSourceKind.collect)
                
                // update the overlay
                self.overlay?.collectedGemsCount = self.collectedGems
                
                if self.collectedGems == 1 {
                    //we collect a gem, show the key after 1 second
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
                                                    Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                                                        self.keyShouldAppear()
                                                    })
                }
            }
            
            collectable.physicsBody = nil //not collectable anymore
            
            // particles
            addParticles(with: .keyApparition, withTransform: collectable.worldTransform)
            
            collectable.removeFromParentNode()
        }
    }
}
