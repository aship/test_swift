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
        self.backgroundColor = UIColor(red: 0.09,
                                       green: 0.15,
                                       blue: 0.3,
                                       alpha: 1)
        // スコアを表示する
        let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
        
        //let gameSKView = self.view as! GameSKView
        scoreLabel.text = "SCORE:\(self.score)"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 0,
                                      y: 100)
        self.addChild(scoreLabel)
        
        // ゲームオーバーを表示する
        endLabel.text = "GAMEOVER"
        endLabel.fontSize = 50
        endLabel.fontColor = UIColor.yellow
        endLabel.position = CGPoint(x: 0,
                                    y: 200)
        self.addChild(endLabel)
        
        // リプレイボタンを表示する
        replayLabel.text = "REPLAY"
        replayLabel.fontSize = 40
        replayLabel.position = CGPoint(x: 0,
                                       y: -150)
        self.addChild(replayLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチした位置にあるものを調べる
            let location = touch.location(in: self)
            let touchNode = self.atPoint(location)
            
            if touchNode == replayLabel {
                let scene = TitleScene()
                scene.scaleMode = .resizeFill
                scene.anchorPoint = CGPoint(x: 0.5,
                                            y: 0.5)
                self.view?.presentScene(scene)
            }
        }
    }
}
