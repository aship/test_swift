//
//  GameScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // 衝突する物体の種類を用意する
    let category_player:UInt32  = 1 << 1   // 0001
    let category_marsh:UInt32   = 1 << 2   // 0010
    let category_ground:UInt32  = 1 << 3   // 0100
    let category_other:UInt32   = 1 << 4   // 1000
    // 地面を用意する
    let groundSprite = SKSpriteNode(imageNamed: "ground.png")
   
    // 障害物の準備をする
    var pinCount = 4
    var pinVX:[CGFloat] = []
    var pinSprite:[SKSpriteNode] = []
    
    // タイマーを用意する
    var myTimer = Timer()
    // プレイヤーを用意する
    let playerSprite = SKSpriteNode(imageNamed: "player1.png")
    // スコア表示を用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    // ミス表示を用意する
    var missCount = 0
    let missLabel = SKLabelNode(fontNamed:"Verdana-bold")
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        // 背景色をつける
        self.backgroundColor = UIColor(red: 0.8,
                                       green: 0.96,
                                       blue: 1,
                                       alpha: 1)
        // 物理空間の外枠を作る
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // 物理衝突の情報を自分で受け取る
        self.physicsWorld.contactDelegate = self
        // 物理空間の外枠の種類は、その他
        self.physicsBody?.categoryBitMask = category_other
        
        // ミスを表示する
        missLabel.text = "MISS:0"
        missLabel.fontSize = 20
        missLabel.fontColor = SKColor.black
        missLabel.horizontalAlignmentMode = .left
        missLabel.position = CGPoint(x: 50,
                                     y: 250)
        self.addChild(missLabel)
        
        // スコアを表示する
        scoreLabel.text = "SCORE:0"
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: -150,
                                      y: 250)
        self.addChild(scoreLabel)
        
        // 地面を表示する
        groundSprite.physicsBody = SKPhysicsBody(rectangleOf: groundSprite.size)
        groundSprite.physicsBody?.isDynamic = false                   // 重力の影響を受けない
        groundSprite.physicsBody?.categoryBitMask = category_ground // 種類は、地面
        groundSprite.position = CGPoint(x: 0,
                                        y: -360)
        self.addChild(groundSprite)
        
        // プレイヤーを表示する
        playerSprite.position = CGPoint(x: 0,
                                        y: -260)
        playerSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)    // 物理ボディは半径50の円
        playerSprite.physicsBody?.isDynamic = false
        playerSprite.physicsBody?.categoryBitMask = category_player
        playerSprite.setScale(0.5)
        self.addChild(playerSprite)
        
        // プレイヤーにパラパラアニメをするアクションをつける
        let playerAnime = SKAction.animate(with: [SKTexture(imageNamed: "player1.png"),
                                                  SKTexture(imageNamed: "player2.png")],
                                           timePerFrame: 0.2)
        let actionA = SKAction.repeatForever(playerAnime)
        playerSprite.run(actionA)
        
        // 途中の障害物を表示する
        for i in 0 ..< pinCount {
            // 障害物のスプライトを作る
            let pin = SKSpriteNode(imageNamed: "pin.png")
            pin.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            // 重力の影響を受けない
            pin.physicsBody?.isDynamic = false
            pin.physicsBody?.categoryBitMask = category_other
            pin.setScale(0.5)
            
            // ランダムな位置に登場させる
            let rx = Int(arc4random_uniform(UInt32(screenWidth))) - Int(screenWidth) / 2
            let ry = i * 100 - 100
            
            pin.position = CGPoint(x: rx,
                                   y: ry)
            self.addChild(pin)
            
            // 作った障害物を配列に追加する
            pinSprite.append(pin)
            
            // 移動スピードもランダムに作って配列に追加する
            let speed = CGFloat(arc4random() % 20) - 10
            pinVX.append(speed)
            
            print("SPPPEDDD \(speed)")
        }
        
        // タイマーをスタートする（1.0秒ごとにtimerUpdateを繰り返し実行）
        myTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                       target: self,
                                       selector: #selector(self.timerUpdate),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    // タイマーで 1 秒ごとに実行される処理
    @objc func timerUpdate() {
        // マシュマロのスプライトを作る
        let marsh = SKSpriteNode(imageNamed: "marsh1.png")
        marsh.physicsBody = SKPhysicsBody(circleOfRadius: 50)   // 物理ボディは半径50の円
        marsh.physicsBody?.restitution = 0.6    // 跳ね返り係数を0.6にして弾みやすくする
        
        marsh.physicsBody?.categoryBitMask = category_marsh // 種類は、マシュマロ
        // マシュマロが衝突するものは、プレイヤー、マシュマロ、地面、その他
        marsh.physicsBody?.collisionBitMask = category_player | category_marsh | category_ground | category_other
        // マシュマロが衝突した時に反応する物は、プレイヤーと地面
        marsh.physicsBody?.contactTestBitMask = category_player | category_ground
        marsh.setScale(0.5)
        // 横方向にランダム、縦方向に1000（画面の上の方）の位置に登場させる
        marsh.position = CGPoint(x: -100 + Int(arc4random_uniform(200)),
                                 y: 260)
        self.addChild(marsh)
        
        // マシュマロが登場したときに、衝撃を与えて、斜め上方向に飛び出させる
        let vec = CGVector(dx: Int(arc4random_uniform(200)) - 100,
                           dy: 100)
        marsh.physicsBody?.applyImpulse(vec)
    }
}
