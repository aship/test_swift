//
//  GameObjectFriends.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    // MARK: - Friends
    
    func updateFriends(deltaTime: CFTimeInterval) {
        let pathCurve: Float = 0.4
        
        // update pandas
        for i in 0..<friendCount {
            let friend = friends[i]
            
            var pos = friend.simdPosition
            let offsetx = pos.x - sinf(pathCurve * pos.z)
            
            pos.z += friendsSpeed[i] * Float(deltaTime) * 0.5
            pos.x = sinf(pathCurve * pos.z) + offsetx
            
            friend.simdPosition = pos
            
            ensureNoPenetrationOfIndex(i)
        }
    }
    
    func animateFriends() {
        //animations
        let walkAnimation = Character.loadAnimation(fromSceneNamed: "Art.scnassets/character/max_walk.scn")
        
        SCNTransaction.begin()
        for i in 0..<friendCount {
            //unsynchronize
            let walk = walkAnimation.copy() as! SCNAnimationPlayer
            walk.speed = CGFloat(friendsSpeed[i])
            friends[i].addAnimationPlayer(walk, forKey: "walk")
            walk.play()
        }
        SCNTransaction.commit()
    }
    
    func addFriends(_ count: Int) {
        var count = count
        if count + friendCount > GameObject.NumberOfFiends {
            count = GameObject.NumberOfFiends - friendCount
        }
        
        let friendScene = SCNScene(named: "Art.scnassets/character/max.scn")
        guard let friendModel = friendScene?.rootNode.childNode(withName: "Max_rootNode", recursively: true) else { return }
        friendModel.name = "friend"
        
        var textures = [String](repeating: "", count: 3)
        textures[0] = "Art.scnassets/character/max_diffuseB.png"
        textures[1] = "Art.scnassets/character/max_diffuseC.png"
        textures[2] = "Art.scnassets/character/max_diffuseD.png"
        
        var geometries = [SCNGeometry](repeating: SCNGeometry(), count: 3)
        guard let geometryNode = friendModel.childNode(withName: "Max", recursively: true) else { return }
        
        geometryNode.geometry!.firstMaterial?.diffuse.intensity = 0.5
        
        geometries[0] = geometryNode.geometry!.copy() as! SCNGeometry
        geometries[1] = geometryNode.geometry!.copy() as! SCNGeometry
        geometries[2] = geometryNode.geometry!.copy() as! SCNGeometry
        
        geometries[0].firstMaterial = geometries[0].firstMaterial?.copy() as? SCNMaterial
        geometryNode.geometry?.firstMaterial?.diffuse.contents = "Art.scnassets/character/max_diffuseB.png"
        
        geometries[1].firstMaterial = geometries[1].firstMaterial?.copy() as? SCNMaterial
        geometryNode.geometry?.firstMaterial?.diffuse.contents = "Art.scnassets/character/max_diffuseC.png"
        
        geometries[2].firstMaterial = geometries[2].firstMaterial?.copy() as? SCNMaterial
        geometryNode.geometry?.firstMaterial?.diffuse.contents = "Art.scnassets/character/max_diffuseD.png"
        
        //remove physics from our friends
        friendModel.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
            node.physicsBody = nil
        })
        
        let friendPosition = simd_make_float3(-5.84, -0.75, 3.354)
        let FRIEND_AREA_LENGTH: Float = 5.0
        
        // group them
        var friendsNode: SCNNode? = scene!.rootNode.childNode(withName: "friends", recursively: false)
        if friendsNode == nil {
            friendsNode = SCNNode()
            friendsNode!.name = "friends"
            scene!.rootNode.addChildNode(friendsNode!)
        }
        
        //animations
        let idleAnimation = Character.loadAnimation(fromSceneNamed: "Art.scnassets/character/max_idle.scn")
        for _ in 0..<count {
            let friend = friendModel.clone()
            
            //replace texture
            let geometryIndex = Int(arc4random_uniform(UInt32(3)))
            guard let geometryNode = friend.childNode(withName: "Max", recursively: true) else { return }
            geometryNode.geometry = geometries[geometryIndex]
            
            //place our friend
            friend.simdPosition = simd_make_float3(
                friendPosition.x + (1.4 * (Float(arc4random_uniform(UInt32(RAND_MAX))) / Float(RAND_MAX)) - 0.5),
                friendPosition.y,
                friendPosition.z - (FRIEND_AREA_LENGTH * (Float(arc4random_uniform(UInt32(RAND_MAX))) / Float(RAND_MAX))))
            
            //unsynchronize
            let idle = (idleAnimation.copy() as! SCNAnimationPlayer)
            idle.speed = CGFloat(Float(1.5) + Float(1.5) * Float(arc4random_uniform(UInt32(RAND_MAX))) / Float(RAND_MAX))
            
            friend.addAnimationPlayer(idle, forKey: "idle")
            idle.play()
            friendsNode?.addChildNode(friend)
            
            self.friendsSpeed[friendCount] = Float(idle.speed)
            self.friends[friendCount] = friend
            self.friendCount += 1
        }
        
        for i in 0..<friendCount {
            ensureNoPenetrationOfIndex(i)
        }
    }
    
    // iterates on every friend and move them if they intersect friend at index i
    func ensureNoPenetrationOfIndex(_ index: Int) {
        var pos = friends[index].simdPosition
        
        // ensure no penetration
        let pandaRadius: Float = 0.15
        let pandaDiameter = pandaRadius * 2.0
        for j in 0..<friendCount {
            if j == index {
                continue
            }
            
            let otherPos = SIMD3<Float>(friends[j].position)
            let v = otherPos - pos
            let dist = simd_length(v)
            if dist < pandaDiameter {
                // penetration
                let pen = pandaDiameter - dist
                pos -= simd_normalize(v) * pen
            }
        }
        
        //ensure within the box X[-6.662 -4.8] Z<3.354
        if friends[index].position.z <= 3.354 {
            pos.x = max(pos.x, -6.662)
            pos.x = min(pos.x, -4.8)
        }
        friends[index].simdPosition = pos
    }
}
