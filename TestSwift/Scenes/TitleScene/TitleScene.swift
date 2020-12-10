//
//  TitleScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/22.
//

import SpriteKit

class TitleScene: SKScene {
    let titleLabel = SKLabelNode(fontNamed: "Verdana-bold")
    let startLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.brown
        
        // タイトルを表示する
        titleLabel.text = "もぐらたたきゲーム"
        titleLabel.fontSize = 36
        titleLabel.position = CGPoint(x: 0,
                                      y: 200)
        self.addChild(titleLabel)
        
        // スタートボタンを表示する
        startLabel.text = "START"
        startLabel.fontSize = 60
        startLabel.position = CGPoint(x: 0,
                                      y: -200)
        self.addChild(startLabel)
    }
    // タッチしたときの処理
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)   // タッチした位置を調べて
            let touchNode = self.atPoint(location)  // その位置にあるものを調べる
            // もし、タッチした位置にあるものがスタートボタンなら
            if touchNode == startLabel {
                let scene = GameScene(size: self.size)
                
                self.view?.presentScene(scene)
            }
        }
    }
}
