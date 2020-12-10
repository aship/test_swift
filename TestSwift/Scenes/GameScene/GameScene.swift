//
//  GameScene.swift
//  ShrimpSwim
//
//  Created by 村田 知常 on 2015/12/28.
//  Copyright (c) 2015年 shoeisha. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // MARK: - 定数定義
    /// 定数
    struct Constants {
        /// Player画像
        static let PlayerImages = ["shrimp01", "shrimp02", "shrimp03", "shrimp04"]
    }
    
    /// 衝突の判定につかうBitMask
    struct ColliderType {
        /// プレイキャラに設定するカテゴリ
        static let Player: UInt32 = (1 << 0)
        /// 天井・地面に設定するカテゴリ
        static let World: UInt32  = (1 << 1)
        /// サンゴに設定するカテゴリ
        static let Coral: UInt32  = (1 << 2)
        /// スコア加算用SKNodeに設定するカテゴリ
        static let Score: UInt32  = (1 << 3)
        /// スコア加算用SKNodeに衝突した際に設定するカテゴリ
        static let None: UInt32   = (1 << 4)
    }
    
    // MARK: - 変数定義
    /// プレイキャラ以外の移動オブジェクトを追加する空ノード
    var baseNode: SKNode!
    /// サンゴ関連のオブジェクトを追加する空ノード(リスタート時に活用)
    var coralNode: SKNode!
    
    /// プレイキャラ
    var player: SKSpriteNode!
    
    /// スコアを表示するラベル
    var scoreLabelNode: SKLabelNode!
    /// スコアの内部変数
    var score: UInt32!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var counter = 0
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        print("size")
        print(screenWidth)
        print(screenHeight)
        
        // 変数の初期化
        score = 0
        
        // 物理シミュレーションを設定
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        self.physicsWorld.contactDelegate = self
        
        // 全ノードの親となるノードを生成
        baseNode = SKNode()
        baseNode.speed = 0.0
        self.addChild(baseNode)
        
        // 障害物を追加するノードを生成
        coralNode = SKNode()
        baseNode.addChild(coralNode)
        
        self.setupBackgroundSea()
        self.setupBackgroundRockUnder()
        self.setupBackgroundRockAbove()
        self.setupLand()
        self.setupCeiling()
        self.setupPlayer()
        self.setupCoral()
        self.setupScoreLabel()
    }

    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
