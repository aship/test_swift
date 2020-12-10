//
//  GameSceneBackground.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    func setupBackgroundSea() {
        // 背景画像を読み込む
        let texture = SKTexture(imageNamed: "background")
        texture.filteringMode = .nearest
        
        let textureWidth = texture.size().width
        
        // 左に画像一枚分移動アニメーションを作成
        let moveAnim = SKAction.moveBy(x: -screenWidth,
                                       y: 0.0,
                                       duration: TimeInterval(screenWidth / 10.0))
        // 元の位置に戻すアニメーションを作成
        let resetAnim = SKAction.moveBy(x: screenWidth,
                                        y: 0.0,
                                        duration: 0.0)
        
        let repeatAction = SKAction.sequence([moveAnim, resetAnim])
        
        // 移動して元に戻すアニメーションを繰り返すアニメーションを作成
        let repeatForeverAnim = SKAction.repeatForever(repeatAction)
        
        // 画像の配置とアニメーションを設定
        for num in 0 ..< 2 {
            let i: CGFloat = CGFloat(num)
            // SKTextureからSKSpriteNodeを作成
            let sprite = SKSpriteNode(texture: texture)
            // 一番奥に配置
            sprite.zPosition = -100.0
            
            let scale = screenWidth / textureWidth
            
            sprite.setScale(scale)
            sprite.position = CGPoint(x: i * screenWidth,
                                      y: 0)
            
            sprite.run(repeatForeverAnim)
            baseNode.addChild(sprite)
        }
    }
}
