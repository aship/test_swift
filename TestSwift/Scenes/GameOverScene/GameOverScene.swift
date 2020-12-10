//
//  GameOverScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/22.
//

import SpriteKit

class GameOverScene: SKScene {
    var score = 0
    
    // ゲームオーバー用ラベルと、リプレイボタン用ラベルを用意する
    let endLabel = SKLabelNode(fontNamed: "Verdana-bold")
    let replayLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        // 背景色をつける
        self.backgroundColor = UIColor(red: 0.8, green: 0.96, blue: 1, alpha: 1)
        // スコアを表示する
        let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
   //     let gameSKView = self.view as! GameSKView
        scoreLabel.text = "SCORE:\(self.score)"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.brown
        scoreLabel.position = CGPoint(x: 0,
                                      y: 100)
        self.addChild(scoreLabel)
        
        // ゲームオーバーを表示する
        endLabel.text = "GAMEOVER"
        endLabel.fontSize = 50
        endLabel.fontColor = UIColor.magenta
        endLabel.position = CGPoint(x: 0,
                                    y: 200)
        self.addChild(endLabel)
        
        // リプレイボタンを表示する
        replayLabel.text = "REPLAY"
        replayLabel.fontSize = 30
        replayLabel.fontColor = SKColor.brown
        replayLabel.position = CGPoint(x: 0,
                                       y: -200)
        self.addChild(replayLabel)
    }
    // タッチしたときの処理
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチした位置にあるものを調べる
            let location = touch.location(in: self)
            let touchNode = self.atPoint(location)
            // もし、タッチした位置にあるものがリプレイボタンなら
            if touchNode == replayLabel {
                let scene = TitleScene()
                let transition = SKTransition.crossFade(withDuration: 1.0)
                
                self.view?.presentScene(scene,
                                        transition: transition)
            }
        }
    }
}
