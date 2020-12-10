//
//  GameSceneUpdate.swift
//  TestSwift
//
//  Created by aship on 2020/11/09.
//

import SpriteKit

extension GameScene {
    override func update(_ currentTime: CFTimeInterval) {
        // スコアを増やして、表示する
        score += 5
        scoreLabel.text = "SCORE:\(score)"
        
        fallStar()          // 星を振らせる
        fallMeteo()         // 隕石を振らせる
        checkCollision()    // 衝突判定をする
    }

    // 背景の星を降らせる
    func fallStar() {
        for i in 0 ..< starCount {
            // 星を各スピード量で下へ移動する
            starSprite[i].position.y -= starSpeed[i]
            
            // もし、画面の下まで来たら、画面の上に移動する
            if starSprite[i].position.y < -1 * screenHeight / 2 {
                starSprite[i].position.y = screenHeight / 2
            }
        }
    }
    
    func fallMeteo() {
        for i in 0 ..< meteoCount {
            // 隕石を各スピード量で下へ移動する
            meteoSprite[i].position.y -= meteoSpeed[i]
            // もし、画面の下まで来たら
            if meteoSprite[i].position.y < -1 * screenHeight / 2 {
                // 画面の上にランダムに移動する
                let rx = Int(arc4random_uniform(UInt32(screenWidth))) - Int(screenWidth) / 2
                let ry = Int(arc4random_uniform(UInt32(screenHeight))) + Int(screenHeight) / 2
                
                meteoSprite[i].position = CGPoint(x:rx,
                                                  y:ry)
                // 変化させるために隕石の落下スピードもランダムに変更する
                let speed = CGFloat(arc4random_uniform(25)+5)
                meteoSpeed[i] = speed
            }
        }
    }
    
    func checkCollision() {
        for i in 0 ..< meteoCount {
            // ロケットと隕石の距離を求める
            let dx = rocket.position.x - meteoSprite[i].position.x
            let dy = rocket.position.y - meteoSprite[i].position.y
            let distance = sqrt(dx * dx + dy * dy)
            // もし、距離が90より近ければ衝突処理をする
            if distance < 90 {
                let spk = SKEmitterNode(fileNamed: "mySpark")!
                // 放出する粒子の数を300にする
                spk.numParticlesToEmit = 300
                // 位置を隕石の位置にあわせる
                spk.position = meteoSprite[i].position
                // 火花を表示する
                addChild(spk)
                // 隕石を画面の上に移動させる
                meteoSprite[i].position.y = 1334
                // ミスを 1 追加する
                miss = miss + 1
                missLabel.text = "MISS:\(miss)"
                
                if 4 < miss {
                    let scene = GameOverScene()
                    scene.score = self.score
                    
                    // クロスフェードトランジションを適用しながらシーンを移動する
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    self.view?.presentScene(scene,
                                            transition: transition)
                }
            }
        }
    }
}
