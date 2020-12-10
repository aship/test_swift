//
//  GameOverScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/22.
//

import SpriteKit

class GameOverScene: SKScene {
    let endLabel = SKLabelNode(fontNamed: "Verdana-bold")
    let replayLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    var score = 0
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        // 背景色をつける
        self.backgroundColor = UIColor.brown
        // ゲームオーバーを表示する
        endLabel.text = "GAMEOVER"
        endLabel.fontSize = 40
        endLabel.fontColor = UIColor.yellow
        endLabel.position = CGPoint(x: 0,
                                    y: 200)
        self.addChild(endLabel)
        // リプレイボタンを表示する
        replayLabel.text = "REPLAY"
        replayLabel.fontSize = 30
        replayLabel.position = CGPoint(x: 0,
                                       y: -200)
        self.addChild(replayLabel)
        // スコアを表示する
        let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
        
        scoreLabel.text = "SCORE: \(self.score)"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 0,
                                      y: 100)
        self.addChild(scoreLabel)
    }
    // タッチしたときの処理
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)   // タッチした位置を調べて
            let touchNode = self.atPoint(location)  // その位置にあるものを調べる
            // もし、タッチした位置にあるものがリプレイボタンなら
            if touchNode == replayLabel {
                // TitleSceneに切り換える
                let scene = TitleScene()
                scene.anchorPoint = CGPoint(x: 0.5,
                                            y: 0.5)
                scene.scaleMode = .resizeFill
                
                let skView = self.view as SKView?
                skView?.presentScene(scene)
            }
        }
    }
}
