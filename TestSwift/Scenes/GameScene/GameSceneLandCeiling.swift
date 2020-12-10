//
//  GameSceneCeiling.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    /// 天井と地面を構築
    func setupLand() {
        // 地面画像を読み込み
        let land = SKTexture(imageNamed: "land")
        land.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needNumber = 2.0 + (screenWidth / land.size().width)
        
        // 左に画像一枚分移動アニメーションを作成
        let moveLandAnim = SKAction.moveBy(x: -land.size().width,
                                           y: 0.0,
                                           duration:TimeInterval(land.size().width / 100.0))
        // 元の位置に戻すアニメーションを作成
        let resetLandAnim = SKAction.moveBy(x: land.size().width,
                                            y: 0.0,
                                            duration: 0.0)
        
        let repeatAction = SKAction.sequence([moveLandAnim, resetLandAnim])
        
        // 移動して元に戻すアニメーションを繰り返すアニメーションを作成
        let repeatForeverLandAnim = SKAction.repeatForever(repeatAction)
        
        // 画像の配置とアニメーションを設定
        for num in 0 ..< Int(needNumber) {
            let i: CGFloat = CGFloat(num)
            // SKTextureからSKSpriteNodeを作成
            let sprite = SKSpriteNode(texture: land)
            // 画像の初期位置を設定
            sprite.position = CGPoint(x: i * sprite.size.width - 100,
                                      y: -300)
            
            // 画像に物理シミュレーションを設定
            sprite.physicsBody = SKPhysicsBody(texture: land,
                                               size: land.size())
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = ColliderType.World
            // アニメーションを設定
            sprite.run(repeatForeverLandAnim)
            // 親ノードに追加
            baseNode.addChild(sprite)
        }
    }
    
    func setupCeiling() {
        // 天井画像を読み込み
        let ceiling = SKTexture(imageNamed: "ceiling")
        ceiling.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needNumber = 2.0 + screenWidth / ceiling.size().width
        
        let interval = TimeInterval(ceiling.size().width / 100.0)
        
        // 左に画像一枚分移動アニメーションを作成
        let moveCeilingAnim = SKAction.moveBy(x: -ceiling.size().width,
                                              y: 0.0,
                                              duration: interval)
        // 元の位置に戻すアニメaーションを作成
        let resetCeilingAnim = SKAction.moveBy(x: ceiling.size().width,
                                               y: 0.0,
                                               duration: 0.0)
        
        let repeatAction = SKAction.sequence([moveCeilingAnim, resetCeilingAnim])
        
        // 移動して元に戻すアニメーションを繰り返すアニメーションを作成
        let repeatForeverLandAnim = SKAction.repeatForever(repeatAction)
        
        // 画像の配置とアニメーションを設定
        for num in 0 ..< Int(needNumber) {
            let i: CGFloat = CGFloat(num)
            // SKTextureからSKSpriteNodeを作成
            let sprite = SKSpriteNode(texture: ceiling)
            // 画像の初期位置を設定
            sprite.position = CGPoint(x: i * sprite.size.width - 100,
                                      y: 300)
            
            // 画像に物理シミュレーションを設定
            sprite.physicsBody = SKPhysicsBody(texture: ceiling,
                                               size: ceiling.size())
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = ColliderType.World
            
            // アニメーションを設定
            sprite.run(repeatForeverLandAnim)
            // 親ノードに追加
            baseNode.addChild(sprite)
        }
    }
}
