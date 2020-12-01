//
//  GameObjectFollowCamera.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    // the follow camera behavior make the camera to follow
    // the character, with a constant distance,
    // altitude and smoothed motion
    func setupFollowCamera(_ cameraNode: SCNNode) {
        // look at "lookAtTarget"
        let lookAtConstraint = SCNLookAtConstraint(target: self.lookAtTarget)
        lookAtConstraint.influenceFactor = 0.07
        lookAtConstraint.isGimbalLockEnabled = true
        
        // distance constraints
        let follow = SCNDistanceConstraint(target: self.lookAtTarget)
        let distance = CGFloat(simd_length(cameraNode.simdPosition))
        follow.minimumDistance = distance
        follow.maximumDistance = distance
        
        // configure a constraint to maintain a constant altitude relative to the character
        let desiredAltitude = abs(cameraNode.simdWorldPosition.y)
        weak var weakSelf = self
        
        let keepAltitude = SCNTransformConstraint.positionConstraint(inWorldSpace: true, with: {(_ node: SCNNode, _ position: SCNVector3) -> SCNVector3 in
            guard let strongSelf = weakSelf
            else { return position }
            
            var position = SIMD3<Float>(position)
            position.y = strongSelf.character!.baseAltitude + desiredAltitude
            
            return SCNVector3( position )
        })
        
        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.maximumLinearVelocity = 1500.0
        accelerationConstraint.maximumLinearAcceleration = 50.0
        accelerationConstraint.damping = 0.05
        
        // use a custom constraint to let the user orbit
        // the camera around the character
        let transformNode = SCNNode()
        
        let orientationUpdateConstraint = SCNTransformConstraint(inWorldSpace: true) { (_ node: SCNNode, _ transform: SCNMatrix4) -> SCNMatrix4 in
            guard let strongSelf = weakSelf else { return transform }
            
            if strongSelf.activeCamera != node {
                return transform
            }
            
            // Slowly update the acceleration constraint influence factor to smoothly reenable the acceleration.
            accelerationConstraint.influenceFactor = min(1, accelerationConstraint.influenceFactor + 0.01)
            
            let targetPosition = strongSelf.lookAtTarget.presentation.simdWorldPosition
            let cameraDirection = strongSelf.cameraDirection
            
            if cameraDirection.allZero() {
                return transform
            }
            
            // Disable the acceleration constraint.
            accelerationConstraint.influenceFactor = 0
            
            let characterWorldUp = strongSelf.character?.node?.presentation.simdWorldUp
            
            transformNode.transform = transform
            
            let mulX = simd_quaternion(GameObject.CameraOrientationSensitivity * cameraDirection.x,
                                       characterWorldUp!)
            let mulY = simd_quaternion(GameObject.CameraOrientationSensitivity * cameraDirection.y,
                                       transformNode.simdWorldRight)
            
            let quaternion = simd_mul(mulX, mulY)
            
            transformNode.simdRotate(by: quaternion,
                                     aroundTarget: targetPosition)
            return transformNode.transform
        }
        
        cameraNode.constraints = [follow,
                                  keepAltitude,
                                  accelerationConstraint,
                                  orientationUpdateConstraint,
                                  lookAtConstraint]
    }
}
