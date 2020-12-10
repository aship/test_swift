//
//  GameScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    // どんぶり用スプライト
    var bowl:SKSpriteNode?
    
    // 落下用タイマー
    var timer:Timer?
    
    // 落下判定用シェイプ
    var lowestShape:SKShapeNode?
    
    // スコア
    var score = 0
    // スコア用ラベル
    var scoreLabel: SKLabelNode?
    // 名古屋名物ごとのスコア
    var scoreList = [100,
                     200,
                     300,
                     500,
                     800,
                     1000,
                     1500]
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }

    override func didMove(to view: SKView) {
        // 下方向への重力を設定
        self.physicsWorld.gravity = CGVector(dx: 0.0,
                                             dy: -2.0)
        self.physicsWorld.contactDelegate = self
        
        // 背景画像のスプライトを配置
        let background = SKSpriteNode(imageNamed: "background")
        //     background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        background.position = CGPoint(x: 0,
                                      y: 0)
        
        background.setScale(0.6)
        self.addChild(background)
        
        // 落下判定用シェイプ
        let lowestShape = SKShapeNode(rectOf: CGSize(width: screenWidth,
                                                     height: 10))
        // 画面外に配置
        // lowestShape.position = CGPoint(x: self.size.width*0.5, y: -10)
        lowestShape.position = CGPoint(x: 0,
                                       y: -400)
        // lowestShape.fillColor = SKColor.blue
        
        // シェイプの大きさで物理シミュレーションを行う
        let physicsBody = SKPhysicsBody(rectangleOf: lowestShape.frame.size)
        physicsBody.isDynamic = false                 // 落下しないよう固定
        physicsBody.contactTestBitMask = 0x1 << 1   // 名古屋名物との衝突を検知する
        lowestShape.physicsBody = physicsBody
        self.addChild(lowestShape)
        self.lowestShape = lowestShape
        
        // どんぶり用スプライト
        let bowlTexture = SKTexture(imageNamed: "bowl")
        let bowl = SKSpriteNode(texture: bowlTexture)
        
        //  bowl.position = CGPoint(x: self.size.width*0.5, y: 100)
        bowl.position.y = -200
        
        bowl.size = CGSize(width: bowlTexture.size().width * 0.5,
                           height: bowlTexture.size().height * 0.5)
        
        // テクスチャの不透過部分の形状で物理シミュレーションを行う
        bowl.physicsBody = SKPhysicsBody(texture: bowlTexture,
                                         size: bowl.size)
        
        bowl.physicsBody?.isDynamic = false           // 落下しないよう固定
        self.bowl = bowl
        self.addChild(bowl)
        
        // スコア用ラベル
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        // scoreLabel.position = CGPoint(x: self.size.width * 0.92, y: self.size.height * 0.78)
        scoreLabel.position = CGPoint(x: screenWidth * 0.92 / 2 - 20,
                                      y: screenHeight * 0.78 / 2 - 70)
        
        scoreLabel.text = "¥0"
        scoreLabel.fontSize = 32
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right   // 右寄せ
        scoreLabel.fontColor = UIColor.green
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
        
        // 名古屋名物を1つ落下させる
        self.fallNagoyaSpecialty()
        
        // タイマーを作成し一定時間ごとにfallNagoyaSpecialtyメソッドを呼ぶ
        self.timer = Timer.scheduledTimer(timeInterval: 3,
                                          target: self,
                                          selector: #selector(self.fallNagoyaSpecialty),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    // 名古屋名物を落下させるメソッド
    @objc func fallNagoyaSpecialty() {
        // 0〜6のランダムな整数を発生させる
        let index = Int(arc4random_uniform(7))
        let texture = SKTexture(imageNamed: "\(index)") // 選択された番号のテクスチャを読み込む
        
        // テクスチャからスプライトを生成する
        let sprite = SKSpriteNode(texture: texture)
        
        //   sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height)
        sprite.position.y = 300
        
        sprite.size = CGSize(width: texture.size().width * 0.5, height: texture.size().height * 0.5)
        // テクスチャの不透過部分の形状で物理シミュレーションを行う
        sprite.physicsBody = SKPhysicsBody(texture: texture, size: sprite.size)
        
        sprite.physicsBody?.contactTestBitMask = 0x1 << 1   // 落下判定用シェイプとの衝突を検知する
        self.addChild(sprite)
        
        // 落下した物に応じてスコアを加算する
        self.score += self.scoreList[index]
        // 金額のラベルを更新
        self.scoreLabel?.text = "¥\(self.score)"
    }
}
