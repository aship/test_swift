//
//  SKButtonSprite.swift
//  ArrowShooter
//
//  Copyright (c) 2015年 STUDIO SHIN. All rights reserved.
//

import UIKit
import SpriteKit

typealias SKButtonSpriteHandler = () -> Void

class SKButtonSprite: SKSpriteNode {
    
    var handler: SKButtonSpriteHandler!	//タッチされたことを返すクロージャ
    var inContent: Bool = false			//タッチフラグ
    
    //イニシャライザ
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }
    convenience init(imageNamed name: String) {
        
        let texture = SKTexture(imageNamed: name)
        self.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //タッチイベント処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.alpha = 0.5
        self.inContent = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //コンテンツの範囲内であればフラグをONにして半透明にする
        //範囲外ならフラグをOFFにして不透明にする
        for touch in touches {
            var location = touch.location(in: self)
            
            location = CGPoint(x: location.x+(screenWidth/2), y: location.y+(screenHeight/2))
            let rect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            if rect.contains(location) {
                self.alpha = 0.5
                self.inContent = true
            } else {
                self.alpha = 1.0
                self.inContent = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //タッチフラグがONであればクロージャを呼ぶ
        if self.inContent && self.handler != nil {
            self.handler()
        }
        self.alpha = 1.0
    }
}
