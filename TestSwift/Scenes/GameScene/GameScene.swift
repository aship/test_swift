//
//  GameScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SpriteKit

class GameScene: SKScene {
    // ロケットを用意する
    let rocket = SKSpriteNode(imageNamed: "rocket.png")
    
    // 隕石の準備をする
    var meteoCount = 2 //8
    var meteoSpeed:[CGFloat] = []
    var meteoSprite:[SKSpriteNode] = []
    
    // 背景の星を用意する
    var starCount = 10 // 80
    var starSpeed:[CGFloat] = []
    var starSprite:[SKSpriteNode] = []
    
    // スコア表示を用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    // ミス表示を用意する
    var miss = 0
    let missLabel = SKLabelNode(fontNamed: "Verdana-bold")
    // ロケット噴射を用意する
    var rocketspk = SKEmitterNode(fileNamed: "mySpark")!
    
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
        initStar()
        
        // スコアを表示する
        scoreLabel.text = "SCORE:0"
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: -170,
                                      y: 280)
        self.addChild(scoreLabel)
        
        // ミスを表示する
        missLabel.text = "MISS:0"
        missLabel.horizontalAlignmentMode = .left
        missLabel.fontSize = 20
        missLabel.position = CGPoint(x: 60,
                                     y: 280)
        self.addChild(missLabel)
        
        // ロケット噴射を表示する
        // 粒子の放出角度の範囲を0度にする
        rocketspk.emissionAngleRange = 0
        // 粒子の放出角度を真下にする
        rocketspk.emissionAngle = -3.14/2
        // 粒子の生成範囲を横20の幅を持たせる（少し幅を持ったエリアから粒子を放出する）
        rocketspk.particlePositionRange = CGVector(dx: 20,
                                                   dy: 0)
        // 位置を宇宙船の位置にあわせる
        let rocketPosition = CGPoint(x: 0,
                                     y: -260)
        
        rocketspk.particlePosition = rocketPosition
        // 火花を表示する
        addChild(rocketspk)
        
        // ロケットを表示する
        rocket.position = rocketPosition
        self.addChild(rocket)
        
        initMeteo()
    }
}
