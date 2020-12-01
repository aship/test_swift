//
//  GameObjectAxisAlignedCamera.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    // the axis aligned behavior look at the character
    // but remains aligned using a specified axis
    func setupAxisAlignedCamera(_ cameraNode: SCNNode) {
        let distance: Float = simd_length(cameraNode.simdPosition)
        let originalAxisDirection = cameraNode.simdWorldFront
        
        self.lastActiveCameraFrontDirection = originalAxisDirection
        
        let symetricAxisDirection = simd_make_float3(-originalAxisDirection.x, originalAxisDirection.y, -originalAxisDirection.z)
        
        weak var weakSelf = self
        
        // define a custom constraint for the axis alignment
        let axisAlignConstraint = SCNTransformConstraint.positionConstraint(
            inWorldSpace: true, with: {(_ node: SCNNode, _ position: SCNVector3) -> SCNVector3 in
                guard let strongSelf = weakSelf else { return position }
                guard let activeCamera = strongSelf.activeCamera else { return position }
                
                let axisOrigin = strongSelf.lookAtTarget.presentation.simdWorldPosition
                let referenceFrontDirection =
                    strongSelf.activeCamera == node ? strongSelf.lastActiveCameraFrontDirection : activeCamera.presentation.simdWorldFront
                
                let axis = simd_dot(originalAxisDirection, referenceFrontDirection) > 0 ? originalAxisDirection: symetricAxisDirection
                
                let constrainedPosition = axisOrigin - distance * axis
                return SCNVector3(constrainedPosition)
            })
        
        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.maximumLinearAcceleration = 20
        accelerationConstraint.decelerationDistance = 0.5
        accelerationConstraint.damping = 0.05
        
        // look at constraint
        let lookAtConstraint = SCNLookAtConstraint(target: self.lookAtTarget)
        lookAtConstraint.isGimbalLockEnabled = true // keep horizon horizontal
        
        cameraNode.constraints = [axisAlignConstraint, lookAtConstraint, accelerationConstraint]
    }
}
