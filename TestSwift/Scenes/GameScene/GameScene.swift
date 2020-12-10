//
//  GameScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SpriteKit

class GameScene: SKScene {
    let sscale: Float = 0.5
    
    // モグラの位置（[x,y]のセットで5個所）を作る
    let mogPoint = [[200, 300],
                    [600, 400],
                    [300, 600],
                    [650, 700],
                    [250, 900]]
    // モグラを入れる配列を用意する（タッチしたかを調べるため）
    var mogArray:[SKSpriteNode] = []
    
    // スコアと、スコア表示用ラベルを用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    // 残り時間と、残り時間表示用ラベルと、タイマーを用意する
    var timeCount = 20
    
    let timeLabel  = SKLabelNode(fontNamed: "Verdana-bold")
    var myTimer = Timer()
    
    override func sceneDidLoad() {
        self.scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        // 背景色をつける
        self.backgroundColor = SKColor(red: 0.9,
                                       green: 0.84,
                                       blue: 0.71,
                                       alpha: 1)
        // スコアを表示する
        scoreLabel.text = "SCORE:\(score)"
        scoreLabel.fontSize = 24
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: 10,
                                      y: 600)
        self.addChild(scoreLabel)
        
        // モグラの準備をする
        for i in 0...4 {
            let hole = SKSpriteNode(imageNamed: "mog1.png")
            hole.setScale(0.5)
            hole.position = CGPoint(x: Int(Float(mogPoint[i][0]) * sscale),
                                    y: Int(Float(mogPoint[i][1]) * sscale))
            self.addChild(hole)
            
            let mog = SKSpriteNode(imageNamed: "mog2.png")
            mog.setScale(0.5)
            mog.position = CGPoint(x: Int(Float(mogPoint[i][0]) * sscale),
                                   y: Int(Float(mogPoint[i][1]) * sscale))
            self.addChild(mog)
            
            mogArray.append(mog)
            
            // 【モグラが穴から出たり入ったりするアクションをつける】
            // モグラを地下（-1000）に移動するアクション
            let action1 = SKAction.moveTo(y: -1000,
                                          duration: 0.0)
            // 0〜4秒（2秒を中心として前後4秒範囲）でランダムに時間待ち
            let action2 = SKAction.wait(forDuration: 2.0,
                                        withRange: 4.0)
            // もぐらを穴の位置に移動するアクション
            let action3 = SKAction.moveTo(y: hole.position.y,
                                          duration: 0.0)
            // 0〜2秒（1秒を中心として前後2秒範囲）でランダムに時間待ち
            let action4 = SKAction.wait(forDuration: 1.0,
                                        withRange: 2.0)
            // action1〜action4を順番に行う
            let actionS = SKAction.sequence([action1,
                                             action2,
                                             action3,
                                             action4])
            // actionSをずっと繰り返す
            let actionR = SKAction.repeatForever(actionS)
            // モグラに「穴から出たり入ったりするアクション」をつける
            mog.run(actionR)
        }
        // 残り時間を表示する
        timeLabel.text = "Time:\(timeCount)"
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.fontSize = 24
        timeLabel.fontColor = SKColor.black
        timeLabel.position = CGPoint(x: 240,
                                     y: 600)
        self.addChild(timeLabel)
        // タイマーをスタートする（1.0秒ごとにtimerUpdateを繰り返し実行）
        myTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                       target: self,
                                       selector: #selector(self.timerUpdate),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    // タイマーで実行される処理（1.0秒ごとに繰り返し実行）
    @objc func timerUpdate() {
        timeCount = timeCount - 1                             // 残り秒数を 1 減らす
        timeLabel.text = "Time:\(timeCount)"    // 残り秒数を表示
        
        if timeCount < 1 {  // もし 0 になったらゲームオーバー
            // タイマーを停止させる
            myTimer.invalidate()
            
            // GameOverSceneを作り
            let scene = GameOverScene()
            scene.score = self.score
            
            // クロスフェードトランジションを適用しながらシーンを移動する
            let transition = SKTransition.crossFade(withDuration: 1.0)
            self.view?.presentScene(scene,
                                    transition: transition)
        }
    }
}
