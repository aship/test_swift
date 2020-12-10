//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/11/09.
//

import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            // タッチした位置にあるものを調べる
            let touchNode = self.atPoint(location)
            for i in 0...4 {    // 0〜4まで繰り返す
                // もし、タッチしたものがモグラだったら、やっつける
                if touchNode == mogArray[i] {
                    // スコアをアップして、表示する
                    score += 10
                    scoreLabel.text = "SCORE:\(score)"
                    
                    let mog = SKSpriteNode(imageNamed: "mog3.png")  // やられたモグラを作る
                    mog.position = touchNode.position               // 位置を指定する
                    self.addChild(mog)                              // やられたモグラを表示させる
                    
                    // 【モグラに回転しながら上に飛び出して消えるアクションをつける】
                    // モグラを１回転するアクション
                    let action1 = SKAction.rotate(byAngle: 6.28,
                                                  duration: 0.3)
                    // モグラを上に100移動するアクション
                    let action2 = SKAction.moveTo(y: touchNode.position.y + 150,
                                                  duration: 0.3)
                    // action1とaction2を同時に行う
                    let actionG = SKAction.group([action1, action2])
                    // モグラを削除するアクション
                    let action3 = SKAction.removeFromParent()
                    // actionGとaction3を順番に行う
                    let actionS = SKAction.sequence([actionG, action3])
                    // モグラに「回転しながら上に飛び出して消えるアクション」をつける
                    mog.run(actionS)
                    
                    touchNode.position.y = -1000            // モグラを地下（-1000）に移動して消す
                }
            }
        }
    }
}
