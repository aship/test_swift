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
            // タッチされた位置にあるものを調べて
            let location = touch.location(in: self)
            let touchNode = self.atPoint(location)
            // もし、ボタンなら
            if touchNode == btnSprite {
                // ???と表示してから、おみくじを振る
                myLabel.text = "???"
                shakeOmikuji()
            }
        }
    }
    
    private func shakeOmikuji() {
        // 【おみくじを振るアクションをつける】
        // おみくじを少し右に傾けるアクション
        let action1 = SKAction.rotate(toAngle: -0.3,
                                      duration: 0.2)
        // おみくじを少し左に傾けるアクション
        let action2 = SKAction.rotate(toAngle: 0.3,
                                      duration: 0.2)
        // おみくじをひっくり返すアクション
        let action3 = SKAction.rotate(toAngle: 3.14,
                                      duration: 0.2)
        // action1,action2,action3を指定した順番に行う
        let actionS = SKAction.sequence([action1, action2, action1, action2, action1, action3])
        
        // おみくじに「左右に振ってひっくり返すアクション」をつけて、最後にkekkaを実行する
        mySprite.run(actionS,
                     completion: showOmikuji)
    }
    
    private func showOmikuji() {
        let omikuji = ["大吉","中吉","吉","凶"]
        let r = Int(arc4random_uniform(4))
        
        myLabel.text = omikuji[r]
    }
}
