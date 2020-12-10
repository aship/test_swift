//
//  GameSceneLabel.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //ボールのy座標が0より下になったらゲームオーバー
        if gameoverFlg == false {
            if ball.position.y < 0 {
                self.gameover()
            }
        }
    }
    
    func gameover(){
        gameoverLabel.text = "ゲームオーバー"
        gameoverLabel.fontSize = 30
        gameoverLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)
        gameoverLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(gameoverLabel)
        
        //ゲームオーバーフラグをtrueにしてゲームオーバーである状態にする
        gameoverFlg = true
    }
}
