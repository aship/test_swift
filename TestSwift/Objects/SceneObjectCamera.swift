//
//  SceneObjectCamera.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {
    // MARK: Managing the Camera
    
    func panCamera(_ direction: SIMD2<Float>) {
        if lockCamera {
            return
        }
        
        var directionToPan = direction
        
        #if os(iOS) || os(tvOS)
        directionToPan *= SIMD2<Float>(1.0, -1.0)
        #endif
        
        let F = SCNFloat(0.005)
        
        // Make sure the camera handles are correctly reset
        // (because automatic camera animations may have put
        // the "rotation" in a weird state.
        SCNTransaction.animateWithDuration(0.0) {
            self.cameraYHandle.removeAllActions()
            self.cameraXHandle.removeAllActions()
            
            if self.cameraYHandle.rotation.y < 0 {
                self.cameraYHandle.rotation = SCNVector4(0, 1, 0,
                                                         -self.cameraYHandle.rotation.w)
            }
            
            if self.cameraXHandle.rotation.x < 0 {
                self.cameraXHandle.rotation = SCNVector4(1, 0, 0,
                                                         -self.cameraXHandle.rotation.w)
            }
        }
        
        // Update the camera position with some inertia.
        let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        SCNTransaction.animateWithDuration(0.5, timingFunction: timingFunction) {
            let rotationY = self.cameraYHandle.rotation.y
            let rotationW = self.cameraYHandle.rotation.w
            let vectooo = rotationY * (rotationW - SCNFloat(directionToPan.x) * F)
            self.cameraYHandle.rotation = SCNVector4(0, 1, 0, vectooo)
            
            let nnnValue = self.cameraXHandle.rotation.w + SCNFloat(directionToPan.y) * F
            let minValue = min(0.13, nnnValue)
            
            let piii = SCNFloat(-Double.pi / 2)
            let vvv = max(piii, minValue)
            
            self.cameraXHandle.rotation = SCNVector4(1, 0, 0, vvv)
        }
    }
    
    func updateCameraWithCurrentGround(_ node: SCNNode) {
        if gameIsComplete {
            return
        }
        
        if currentGround == nil {
            currentGround = node
            return
        }
        
        // Automatically update the position of the camera when we move to another block.
        if node != currentGround {
            currentGround = node
            
            if var position = groundToCameraPosition[node] {
                if node == mainGround && character.node.position.x < 2.5 {
                    position = SCNVector3(-0.098175, 3.926991, 0.0)
                }
                
                let actionY = SCNAction.rotateTo(x: 0, y: CGFloat(position.y), z: 0, duration: 3.0, usesShortestUnitArc: true)
                actionY.timingMode = .easeInEaseOut
                
                let actionX = SCNAction.rotateTo(x: CGFloat(position.x), y: 0, z: 0, duration: 3.0, usesShortestUnitArc: true)
                actionX.timingMode = .easeInEaseOut
                
                cameraYHandle.runAction(actionY)
                cameraXHandle.runAction(actionX)
            }
        }
    }
}
