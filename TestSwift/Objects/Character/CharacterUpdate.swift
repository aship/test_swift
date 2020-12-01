//
//  CharacterUpdate.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension Character {
    func update(atTime time: TimeInterval,
                with renderer: SCNSceneRenderer) {
        frameCounter += 1
        
        if shouldResetCharacterPosition {
            shouldResetCharacterPosition = false
            resetCharacterPosition()
            return
        }
        
        var characterVelocity = SIMD3<Float>.zero
        
        // setup
        var groundMove = SIMD3<Float>.zero
        
        // did the ground moved?
        if groundNode != nil {
            let groundPosition = groundNode!.simdWorldPosition
            groundMove = groundPosition - groundNodeLastPosition
        }
        
        characterVelocity = SIMD3<Float>(groundMove.x, 0, groundMove.z)
        
        let direction = characterDirection(withPointOfView:renderer.pointOfView)
        
        if previousUpdateTime == 0.0 {
            previousUpdateTime = time
        }
        
        let deltaTime = time - previousUpdateTime
        let characterSpeed = CGFloat(deltaTime) * Character.speedFactor * walkSpeed
        let virtualFrameCount = Int(deltaTime / (1 / 60.0))
        previousUpdateTime = time
        
        // move
        if !direction.allZero() {
            characterVelocity = direction * Float(characterSpeed)
            var runModifier = Float(1.0)
            #if os(OSX)
            if NSEvent.modifierFlags.contains(.shift) {
                runModifier = 2.0
            }
            #endif
            walkSpeed = CGFloat(runModifier * simd_length(direction))
            
            // move character
            directionAngle = CGFloat(atan2f(direction.x, direction.z))
            
            isWalking = true
        } else {
            isWalking = false
        }
        
        // put the character on the ground
        let up = SIMD3<Float>(0, 1, 0)
        var wPosition = characterNode.simdWorldPosition
        // gravity
        downwardAcceleration -= Character.gravity
        wPosition.y += downwardAcceleration
        let HIT_RANGE = Float(0.2)
        var p0 = wPosition
        var p1 = wPosition
        p0.y = wPosition.y + up.y * HIT_RANGE
        p1.y = wPosition.y - up.y * HIT_RANGE
        
        let options: [String: Any] = [
            SCNHitTestOption.backFaceCulling.rawValue: false,
            SCNHitTestOption.categoryBitMask.rawValue: Character.collisionMeshBitMask,
            SCNHitTestOption.ignoreHiddenNodes.rawValue: false]
        
        let hitFrom = SCNVector3(p0)
        let hitTo = SCNVector3(p1)
        let hitResult = renderer.scene!.rootNode.hitTestWithSegment(from: hitFrom, to: hitTo, options: options).first
        
        let wasTouchingTheGroup = groundNode != nil
        groundNode = nil
        var touchesTheGround = false
        let wasBurning = isBurning
        
        if let hit = hitResult {
            let ground = SIMD3<Float>(hit.worldCoordinates)
            if wPosition.y <= ground.y + Character.collisionMargin {
                wPosition.y = ground.y + Character.collisionMargin
                if downwardAcceleration < 0 {
                   downwardAcceleration = 0
                }
                groundNode = hit.node
                touchesTheGround = true
                
                //touching lava?
                isBurning = groundNode?.name == "COLL_lava"
            }
        } else {
            if wPosition.y < Character.minAltitude {
                wPosition.y = Character.minAltitude
                //reset
                queueResetCharacterPosition()
            }
        }
        
        groundNodeLastPosition = (groundNode != nil) ? groundNode!.simdWorldPosition: SIMD3<Float>.zero
        
        //jump -------------------------------------------------------------
        if jumpState == 0 {
            if isJump && touchesTheGround {
                downwardAcceleration += Character.jumpImpulse
                jumpState = 1
                
                model.animationPlayer(forKey: "jump")?.play()
            }
        } else {
            if jumpState == 1 && !isJump {
                jumpState = 2
            }
            
            if downwardAcceleration > 0 {
                for _ in 0..<virtualFrameCount {
                    downwardAcceleration *= jumpState == 1 ? 0.99: 0.2
                }
            }
            
            if touchesTheGround {
                if !wasTouchingTheGroup {
                    model.animationPlayer(forKey: "jump")?.stop(withBlendOutDuration: 0.1)
                    
                    // trigger jump particles if not touching lava
                    if isBurning {
                        model.childNode(withName: "dustEmitter", recursively: true)?.addParticleSystem(jumpDustParticle)
                    } else {
                        // jump in lava again
                        if wasBurning {
                            characterNode.runAction(SCNAction.sequence([
                                SCNAction.playAudio(catchFireSound, waitForCompletion: false),
                                SCNAction.playAudio(ouchSound, waitForCompletion: false)
                                ]))
                        }
                    }
                }
                
                if !isJump {
                    jumpState = 0
                }
            }
        }
        
        if touchesTheGround && !wasTouchingTheGroup && !isBurning && lastStepFrame < frameCounter - 10 {
            // sound
            lastStepFrame = frameCounter
            characterNode.runAction(SCNAction.playAudio(steps[0], waitForCompletion: false))
        }
        
        if wPosition.y < characterNode.simdPosition.y {
            wPosition.y = characterNode.simdPosition.y
        }
        //------------------------------------------------------------------
        
        // progressively update the elevation node when we touch the ground
        if touchesTheGround {
            targetAltitude = wPosition.y
        }
        
        baseAltitude *= 0.95
        baseAltitude += targetAltitude * 0.05
        
        characterVelocity.y += downwardAcceleration
        
        if simd_length_squared(characterVelocity) > 10E-4 * 10E-4 {
            let startPosition = characterNode!.presentation.simdWorldPosition + collisionShapeOffsetFromModel
            slideInWorld(fromPosition: startPosition, velocity: characterVelocity)
        }
    }
}
