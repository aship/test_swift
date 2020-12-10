//
//  CharactorNodeDirection.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension CharactorNode {
    // 動作設定
    func setCharaDirection(_ charaDirection: CharaDirection) {
        //テクスチャーアニメーション停止中か、異なる設定の場合
        
        
//        print("setCharaDirection inTextureAnime \(self.inTextureAnime)")
//        print("self.charaDirection \(self.charaDirection)")
//        print("charaDirection \(charaDirection)")
//        print("------------")
//
        
        
        if self.inTextureAnime == false ||
            self.charaDirection != charaDirection {
            self.charaDirection = charaDirection
            
            var action: SKAction? = nil
            var direction: String
            
            if self.charaDirection == .kCharaDirectionRight {
                direction = "right"
                //右
            } else if self.charaDirection == .kCharaDirectionUp {
                direction = "up"
                //上
            } else if self.charaDirection == .kCharaDirectionLeft {
                direction = "left"
                //左
            } else {
                direction = "down"
                //下
            }
            
            let ary: [SKTexture] = [self.textureAtlas.textureNamed("\(self.name!)_\(direction)1"),
                                    self.textureAtlas.textureNamed("\(self.name!)_\(direction)2"),
                                    self.textureAtlas.textureNamed("\(self.name!)_\(direction)3")]
            
            action = SKAction.animate(with: ary,
                                      timePerFrame: Double(self.animeSpeed),
                                      resize: true,
                                      restore: true)
            //NSLog(@"%@ %d", name, charaDirection);
            
            //テクスチャアニメーション設定
            self.inTextureAnime = true
            self.run(SKAction.repeatForever(action!),
                     withKey: "charaMove")
        }
    }
    
    
    
}
