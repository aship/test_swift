//
//  GameObjectActiveCamera.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    // MARK: - Camera transitions
    
    // transition to the specified camera
    // this method will reparent the main camera
    // under the camera named "cameraNamed"
    // and trigger the animation to smoothly move
    // from the current position to the new position
    func setActiveCamera(_ cameraName: String,
                         animationDuration duration: CFTimeInterval) {
        guard let camera = scene.rootNode.childNode(withName: cameraName,
                                                     recursively: true)
        else { return }
        
        if self.activeCamera == camera {
            return
        }
        
        self.lastActiveCamera = activeCamera
        
        if activeCamera != nil {
            self.lastActiveCameraFrontDirection = (activeCamera?.presentation.simdWorldFront)!
        }
        
        self.activeCamera = camera
        
        // save old transform in world space
        let oldTransform: SCNMatrix4 = cameraNode.presentation.worldTransform
        
        // re-parent
        camera.addChildNode(cameraNode)
        
        // compute the old transform relative to our new parent node
        // (yeah this is the complex part)
        let parentTransform = camera.presentation.worldTransform
        let parentInv = SCNMatrix4Invert(parentTransform)
        
        // with this new transform our position is unchanged in workd space
        // (i.e we did re-parent but didn't move).
        cameraNode.transform = SCNMatrix4Mult(oldTransform, parentInv)
        
        // now animate the transform to identity to smoothly move to the new desired position
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        cameraNode.transform = SCNMatrix4Identity
        
        if let cameraTemplate = camera.camera {
            cameraNode.camera!.fieldOfView = cameraTemplate.fieldOfView
            cameraNode.camera!.wantsDepthOfField = cameraTemplate.wantsDepthOfField
            cameraNode.camera!.sensorHeight = cameraTemplate.sensorHeight
            cameraNode.camera!.fStop = cameraTemplate.fStop
            cameraNode.camera!.focusDistance = cameraTemplate.focusDistance
            cameraNode.camera!.bloomIntensity = cameraTemplate.bloomIntensity
            cameraNode.camera!.bloomThreshold = cameraTemplate.bloomThreshold
            cameraNode.camera!.bloomBlurRadius = cameraTemplate.bloomBlurRadius
            cameraNode.camera!.wantsHDR = cameraTemplate.wantsHDR
            cameraNode.camera!.wantsExposureAdaptation = cameraTemplate.wantsExposureAdaptation
            cameraNode.camera!.vignettingPower = cameraTemplate.vignettingPower
            cameraNode.camera!.vignettingIntensity = cameraTemplate.vignettingIntensity
        }
        
        SCNTransaction.commit()
    }
    
    func setActiveCamera(_ cameraName: String) {
        setActiveCamera(cameraName, animationDuration: GameObject.DefaultCameraTransitionDuration)
    }
}
