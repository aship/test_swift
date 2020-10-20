//
//  GameScene.swift
//  fox2-swift iOS
//
//  Created by aship on 2020/10/20.
//  Copyright © 2020 com.apple. All rights reserved.
//

import SceneKit

class GameScene: SCNScene {
    override init() {
        super.init()
        
        self.background.contents = UIColor.black

//        let testGeo = SCNSphere(radius: 1)
//        let testNode = SCNNode(geometry: testGeo)
//        testGeo.firstMaterial?.diffuse.contents = UIColor.yellow
//        self.rootNode.addChildNode(testNode)
//        
//        let testGeo2 = SCNCapsule(capRadius: 0.3,
//                                  height: 2)
//        let testNode2 = SCNNode(geometry: testGeo2)
//        testGeo2.firstMaterial?.diffuse.contents = UIColor.red
//        testNode2.position = SCNVector3(0, 2, 0)
//        self.rootNode.addChildNode(testNode2)
//
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(0, 0, 10)
//        self.rootNode.addChildNode(cameraNode)
//
//        let omniLight = SCNNode()
//        omniLight.light = SCNLight()
//        omniLight.light?.type = .omni
//        omniLight.position = SCNVector3(10, 10, 10)
//        self.rootNode.addChildNode(omniLight)
//
//        let floorGeo = SCNFloor()
//        let floorNode = SCNNode(geometry: floorGeo)
//        floorGeo.firstMaterial?.diffuse.contents = UIColor.green
//        floorNode.position.y = -1
//        self.rootNode.addChildNode(floorNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
