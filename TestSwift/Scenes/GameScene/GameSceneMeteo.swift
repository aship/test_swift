//
//  GameSceneMeteo.swift
//  TestSwift
//
//  Created by aship on 2020/11/09.
//

import SpriteKit

extension GameScene {
    // 隕石を作る
    func initMeteo() {
        for _ in 0 ..< meteoCount {
            print("METEOOOOO")
            // 画面の上の方に隕石を作って表示し、そこから降らせる
            let rock = SKSpriteNode(imageNamed: "meteo.png")
            
            let rx = Int(arc4random_uniform(UInt32(screenWidth))) - Int(screenWidth) / 2
            let ry = Int(arc4random_uniform(UInt32(screenHeight))) + Int(screenHeight) / 2
            
            rock.position = CGPoint(x: rx,
                                    y: ry)
            
            self.addChild(rock)
            // 作った隕石を配列に追加する
            meteoSprite.append(rock)
            // 隕石の移動スピードをランダムに用意して配列に追加する
            let speed = CGFloat(arc4random_uniform(15) + 5)
            meteoSpeed.append(speed)
        }
    }
}
