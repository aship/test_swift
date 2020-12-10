//
//  GameScene.swift
//  ShrimpSwim
//
//  Created by 村田 知常 on 2015/12/28.
//  Copyright (c) 2015年 shoeisha. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, CharacterDelegate {
    // すべてのタイルを保持する配列
    var tileMap = [Tile]()
    // 花のタイルを保持する辞書
    var flowerMap = [Int: SKSpriteNode]()
    // タイルの表示上のサイズ
    var tileSize = CGSize(width: 10.0, height: 10.0)
    // マップの横方向のタイル数
    var mapWidth = 0
    // マップの縦方向のタイル数
    var mapHeight = 0
    
    // プレイヤー
    var player: Player?
    // 敵
    var enemies = [Enemy]()
    
    // スコア用ラベル
    var scoreLabel: SKLabelNode?
    // スコア
    var score = 0
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.0,
                                   y: 0.0)
    }
    
    override func didMove(to view: SKView) {
        // 背景画像のスプライトを貼り付ける
        let backgroundSprite = SKSpriteNode(imageNamed: "background")
        backgroundSprite.size = CGSize(width: screenWidth,
                                       height: screenHeight)
        backgroundSprite.position = CGPoint(x: screenWidth * 0.5,
                                            y: screenHeight * 0.5)
        self.addChild(backgroundSprite)
        
        // マップを描画する
        self.drawMap()
        // プレイヤーを作成する
        self.createPlayer(firstPosition: TilePosition(x: 0, y: 2))
        // 敵を作成する
        self.createEnemy(firstPosition: TilePosition(x: 5, y: 5))
        self.createEnemy(firstPosition: TilePosition(x: 10, y: 5))
        
        // スコアボードを設置する
        let houseSprite = SKSpriteNode(imageNamed: "house")
        houseSprite.size = CGSize(width: 143, height: 91)
        houseSprite.position = CGPoint(x: screenWidth-71, y: 45)
        houseSprite.zPosition = 1   // 他のノードより手前に表示する
        self.addChild(houseSprite)
        
        // スコアのラベルを設置する
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = "0"
        scoreLabel.fontSize = 32
        scoreLabel.position = CGPoint(x: screenWidth-60, y: 40)
        scoreLabel.fontColor = UIColor.black
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
        
        // "points"ラベルを設置する
        let pointsLabel = SKLabelNode(fontNamed: "Helvetica")
        pointsLabel.text = "points"
        pointsLabel.fontSize = 18
        pointsLabel.position = CGPoint(x: screenWidth-60, y: 20)
        pointsLabel.fontColor = UIColor.black
        pointsLabel.zPosition = 1
        self.addChild(pointsLabel)
    }
}
