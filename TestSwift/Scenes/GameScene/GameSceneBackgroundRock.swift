//
//  GameSceneBackgroundRock.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    func setupBackgroundRockUnder() {
        // 岩山(下)画像を読み込む
        let under = SKTexture(imageNamed: "rock_under")
        under.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needNumber = 2.0 + (screenWidth / under.size().width)
        
        // 左に画像一枚分移動アニメーションを作成
        let moveUnderAnim = SKAction.moveBy(x: -under.size().width,
                                            y: 0.0,
                                            duration:TimeInterval(under.size().width / 20.0))
        // 元の位置に戻すアニメーションを作成
        let resetUnderAnim = SKAction.moveBy(x: under.size().width,
                                             y: 0.0,
                                             duration: 0.0)
        
        let repeatAction = SKAction.sequence([moveUnderAnim, resetUnderAnim])
        
        // 移動して元に戻すアニメーションを繰り返すアニメーションを作成
        let repeatForeverUnderAnim = SKAction.repeatForever(repeatAction)
        
        // 画像の配置とアニメーションを設定
        for num in 0 ..< Int(needNumber) {
            let i: CGFloat = CGFloat(num)
            // SKTextureからSKSpriteNodeを作成
            let sprite = SKSpriteNode(texture: under)
            // 背景画像より手前に設定
            sprite.zPosition = -50.0
            // 画像の初期位置を設定
            sprite.position = CGPoint(x: i * sprite.size.width - 100,
                                      y: -240)
            // アニメーションを設定
            sprite.run(repeatForeverUnderAnim)
            // 親ノードに追加
            baseNode.addChild(sprite)
        }
    }
    
    func setupBackgroundRockAbove() {
        // 岩山(上)画像を読み込む
        let above = SKTexture(imageNamed: "rock_above")
        above.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needNumber = 2.0 + (screenWidth / above.size().width)
        
        // 左に画像一枚分移動アニメーションを作成
        let moveAboveAnim = SKAction.moveBy(x: -above.size().width,
                                            y: 0.0,
                                            duration:TimeInterval(above.size().width / 20.0))
        // 元の位置に戻すアニメーションを作成
        let resetAboveAnim = SKAction.moveBy(x: above.size().width,
                                             y: 0.0,
                                             duration: 0.0)
        
        let repeatAction = SKAction.sequence([moveAboveAnim, resetAboveAnim])
        // 移動して元に戻すアニメーションを繰り返すアニメーションを作成
        let repeatForeverAboveAnim = SKAction.repeatForever(repeatAction)
        
        // 画像の配置とアニメーションを設定
        for num in 0 ..< Int(needNumber) {
            let i: CGFloat = CGFloat(num)
            // SKTextureからSKSpriteNodeを作成
            let sprite = SKSpriteNode(texture: above)
            // 背景画像より手前に設定
            sprite.zPosition = -50.0
            // 画像の初期位置を設定
            sprite.position = CGPoint(x: i * sprite.size.width - 100,
                                      y: 240)
            // アニメーションを設定
            sprite.run(repeatForeverAboveAnim)
            // 親ノードに追加
            baseNode.addChild(sprite)
        }
    }
}
