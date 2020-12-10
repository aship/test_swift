//
//  CharactorNodeAngle.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension CharactorNode {
    
    func setAngle(_ angle: CGFloat,
                  Velocity velocity: CGFloat) {
        if self.inShootAnime {
            return
        }
        
        self.angle = angle
        
        if velocity == 0 {
            self.stop()
            //停止
        } else {
            let direction = CharactorNode.angleToDirection(CGFloat(self.angle))
            
            if self.charaDirection != direction || (self.velocity == 0 && velocity != 0) {
                //   self.charaDirection = direction
                self.setCharaDirection(direction)
            }
        }
        
        self.velocity = velocity
    }
}
