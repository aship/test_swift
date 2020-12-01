//
//  GameObjectCamera.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    func setupCamera() {
        // The lookAtTarget node will be placed
        // slighlty above the character using a constraint
        weak var weakSelf = self
        
        let constraint = SCNTransformConstraint.positionConstraint(
            inWorldSpace: true,
            with: { (_ node: SCNNode, _ position: SCNVector3) -> SCNVector3 in
                guard let strongSelf = weakSelf else { return position }
                
                guard var worldPosition = strongSelf.character?.node?.simdWorldPosition
                else { return position }
                
                worldPosition.y = strongSelf.character!.baseAltitude + 0.5
                return SCNVector3(worldPosition)
            }
        )
        
        self.lookAtTarget.constraints = [constraint]
        
        self.scene?.rootNode.addChildNode(lookAtTarget)
        
        self.scene?.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.camera != nil {
                self.setupCameraNode(node)
            }
        })
        
        self.cameraNode.camera = SCNCamera()
        self.cameraNode.name = "mainCamera"
        self.cameraNode.camera!.zNear = 0.1
        self.scene!.rootNode.addChildNode(cameraNode)
        
        setActiveCamera("camLookAt_cameraGame", animationDuration: 0.0)
    }
    
    private func setupCameraNode(_ node: SCNNode) {
        guard let cameraName = node.name else { return }
        
        if cameraName.hasPrefix("camTrav") {
            setupAxisAlignedCamera(node)
        } else if cameraName.hasPrefix("camLookAt") {
            setupFollowCamera(node)
        }
    }
}
