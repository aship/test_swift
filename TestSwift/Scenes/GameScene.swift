//
//  GameScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SpriteKit

class GameScene: SKScene {
    let mySprite = SKSpriteNode(imageNamed: "omikuji.png")
    let btnSprite = SKSpriteNode(imageNamed: "button.png")
    let myLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        
        // イラスト
        mySprite.position = CGPoint(x: 0,
                                    y: 200)
        mySprite.setScale(0.5)
        addChild(mySprite)
        
        // おみくじ結果用ラベル
        myLabel.text = "???"
        myLabel.fontSize = 50
        myLabel.fontColor = SKColor.black
        myLabel.position = CGPoint(x: 0,
                                   y: 0)
        self.addChild(myLabel)
        
        // ボタン
        btnSprite.position = CGPoint(x: 0,
                                     y: -200)
        btnSprite.setScale(0.5)
        self.addChild(btnSprite)
    }
}
