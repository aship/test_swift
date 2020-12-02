//
//  SceneObjectEx.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {

    
    // MARK: Moving the Character
    
    func characterDirection() -> SIMD3<Float> {
        let controllerDirection = self.controllerDirection()
        var direction = SIMD3<Float>(controllerDirection.x, 0.0, controllerDirection.y)
        
        if let pov = self.pointOfView {
            let p1 = pov.presentation.convertPosition(SCNVector3(direction), to: nil)
            let p0 = pov.presentation.convertPosition(SCNVector3Zero, to: nil)
            direction = SIMD3<Float>(Float(p1.x - p0.x), 0.0, Float(p1.z - p0.z))
            
            if direction.x != 0.0 || direction.z != 0.0 {
                direction = normalize(direction)
            }
        }
        
        return direction
    }
    
}
