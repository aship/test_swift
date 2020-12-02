//
//  SceneObjectSetupCamera.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {
    func setupCamera() {
         let ALTITUDE = 1.0
        //let ALTITUDE = 0.7
         let DISTANCE = 10.0
       // let DISTANCE = 6.2
        // We create 2 nodes to manipulate the camera:
        // The first node "cameraXHandle" is at the center of the world (0, ALTITUDE, 0)
        // and will only rotate on the X axis
        // The second node "cameraYHandle" is a child of the first one
        // and will ony rotate on the Y axis
        // The camera node is a child of the "cameraYHandle" at a specific distance (DISTANCE).
        // So rotating cameraYHandle and cameraXHandle will update the camera position
        // and the camera will always look at the center of the scene.
        
        let pov = self.pointOfView!
        pov.eulerAngles = SCNVector3Zero
        pov.position = SCNVector3(0.0, 0.0, DISTANCE)
        
        cameraXHandle.rotation = SCNVector4(1.0, 0.0, 0.0,
                                            -Double.pi / 4 * 0.125)
        cameraXHandle.addChildNode(pov)
    
        
        cameraYHandle.position = SCNVector3(0.0, ALTITUDE, 0.0)
        cameraYHandle.rotation = SCNVector4(0.0, 1.0, 0.0,
                                            Double.pi / 2 + Double.pi / 4 * 3.0)
        cameraYHandle.addChildNode(cameraXHandle)
        
        self.scnScene.rootNode.addChildNode(cameraYHandle)
        
        // Animate camera on launch and prevent the user
        // from manipulating the camera until the end of the animation.
        SCNTransaction.animateWithDuration(completionBlock: { self.lockCamera = false }) {
            self.lockCamera = true
            
            // Create 2 additive animations that converge to 0
            // That way at the end of the animation, the camera will be at its default position.
            let cameraYAnimation = CABasicAnimation(keyPath: "rotation.w")
            
            let yFromValue = SCNFloat(Double.pi) * 2.0 - self.cameraYHandle.rotation.w as NSNumber
            cameraYAnimation.fromValue = yFromValue
            cameraYAnimation.toValue = 0.0
            cameraYAnimation.isAdditive = true
            
            // wait a little bit before stating
            cameraYAnimation.beginTime = CACurrentMediaTime() + 8.0
            cameraYAnimation.fillMode = CAMediaTimingFillMode.both
            cameraYAnimation.duration = 5.0
            
            let name = CAMediaTimingFunctionName.easeInEaseOut
            cameraYAnimation.timingFunction = CAMediaTimingFunction(name: name)
    
            self.cameraYHandle.addAnimation(cameraYAnimation, forKey: nil)
            
            let cameraXAnimation = cameraYAnimation.copy() as! CABasicAnimation
            let xFromValue = -SCNFloat(Double.pi / 2) + self.cameraXHandle.rotation.w as NSNumber
            cameraXAnimation.fromValue = xFromValue
    
            self.cameraXHandle.addAnimation(cameraXAnimation, forKey: nil)
        }
    }
    
    func setupAutomaticCameraPositions() {
        let rootNode = self.scnScene.rootNode
        var node = SCNNode()
        
        mainGround = rootNode.childNode(withName: "bloc05_collisionMesh_02",
                                        recursively: true)
        
        node = rootNode.childNode(withName: "bloc04_collisionMesh_02",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3(-0.188683, 4.719608, 0.0)
        
        node = rootNode.childNode(withName: "bloc03_collisionMesh",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3(-0.435909, 6.297167, 0.0)
        
        node = rootNode.childNode(withName: "bloc07_collisionMesh",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3( -0.333663, 7.868592, 0.0)
        
        node = rootNode.childNode(withName: "bloc08_collisionMesh",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3(-0.575011, 8.739003, 0.0)
        
        node = rootNode.childNode(withName: "bloc06_collisionMesh",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3( -1.095519, 9.425292, 0.0)
        
        node = rootNode.childNode(withName: "bloc05_collisionMesh_02",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3(-0.072051, 8.202264, 0.0)
        
        node = rootNode.childNode(withName: "bloc05_collisionMesh_01",
                                  recursively: true)!
        groundToCameraPosition[node] = SCNVector3(-0.072051, 8.202264, 0.0)
    }
}
