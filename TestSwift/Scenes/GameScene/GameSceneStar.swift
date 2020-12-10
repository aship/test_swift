//
//  GameSceneStar.swift
//  TestSwift
//
//  Created by aship on 2020/11/09.
//

import SpriteKit

extension GameScene {
    // 背景の星を作る
    func initStar() {
        for _ in 0 ..< starCount {
            // 星を作る
            let star = SKSpriteNode(imageNamed: "star.png")
            // 画面にランダムに表示する
            let wx = Int(arc4random_uniform(UInt32(screenWidth))) - Int(screenWidth) / 2
            let wy = Int(arc4random_uniform(UInt32(screenHeight))) + Int(screenHeight) / 2
            
            star.position = CGPoint(x: wx, y: wy)
            self.addChild(star)
            
            // 作った星を配列に追加する
            starSprite.append(star)
            
            // 星の落下スピードをランダムに用意して配列に追加する
            let speed = CGFloat(arc4random_uniform(5)+5)
            starSpeed.append(speed)
        }
    }
    
}
