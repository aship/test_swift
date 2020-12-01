//
//  GameObjectPlatform.swift
//  TestSwift
//
//  Created by aship on 2020/12/01.
//

import SceneKit

extension GameObject {
    func setupPlatforms() {
        let PLATFORM_MOVE_OFFSET = Float(1.5)
        let PLATFORM_MOVE_SPEED = Float(0.5)
        
        var alternate: Float = 1
        // This could be done in the editor using the action editor.
        scene!.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.name == "mobilePlatform" && !node.childNodes.isEmpty {
                node.simdPosition = simd_float3(
                    node.simdPosition.x - (alternate * PLATFORM_MOVE_OFFSET / 2.0), node.simdPosition.y, node.simdPosition.z)
                
                let moveAction = SCNAction.move(by: SCNVector3(alternate * PLATFORM_MOVE_OFFSET, 0, 0),
                                                duration: TimeInterval(1 / PLATFORM_MOVE_SPEED))
                moveAction.timingMode = .easeInEaseOut
                node.runAction(SCNAction.repeatForever(SCNAction.sequence([moveAction, moveAction.reversed()])))
                
                alternate = -alternate // alternate movement of platforms to desynchronize them
                
                node.enumerateChildNodes({ (_ child: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) in
                    if child.name == "particles_platform" {
                        child.particleSystems?[0].orientationDirection = SCNVector3(0, 1, 0)
                    }
                })
            }
        })
    }
}
