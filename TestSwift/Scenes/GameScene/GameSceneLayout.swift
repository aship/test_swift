//
//  GameSceneLayout.swift
//  TestSwift
//
//  Created by aship on 2020/11/07.
//

import SpriteKit

extension GameScene {


    
    func layoutObjects(){
        //背景のスプライト
        
        print("self.size \(self.size)")
        
      //  bgSprite.anchorPoint = CGPoint(x:0, y:0)
        bgSprite.zPosition = 1
        bgSprite.size = CGSize(width: screenWidth,
                               height: screenHeight)
        bgSprite.position = CGPoint(x: 180,
                                    y: 320)
        self.addChild(bgSprite)
        
        //ブロック配置用ノード
        self.addChild(blocksNode)
        blocksNode.zPosition = 2
        
        //ブロックの座標を指定するための変数
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        //ブロックを1000個配置します
        for _ in 0..<1000 {
            let blockSprite = SKSpriteNode(imageNamed:"ground")
            blockSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 87, height: 2))
            blockSprite.physicsBody?.collisionBitMask = 1
            blockSprite.physicsBody?.contactTestBitMask = 1
            blockSprite.physicsBody?.allowsRotation = false
            blockSprite.physicsBody?.isDynamic = false
            
            //次のブロックの位置をランダムで配置
            let randIntX = arc4random_uniform(320)
            let randIntY = arc4random_uniform(100)
            x = CGFloat(randIntX)
            y += CGFloat(randIntY)+50       //最低でも50以上、上に配置するようにするため+50
            
            //blocksNodeの上にブロックを配置する
            blocksNode.addChild(blockSprite)
            blockSprite.position = CGPoint(x:x ,y:y)
        }
        
        //キャラクタの配置
        //アンカーポイントの設定
        charaSprite.anchorPoint = CGPoint(x:0.5,y:0)
        //スタート時の位置
        charaSprite.position = CGPoint(x:160,y:100)
        //physicsBodyの設定
        charaSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2, height: 2))
        charaSprite.physicsBody?.linearDamping = 0
        charaSprite.physicsBody?.allowsRotation = false
        charaSprite.physicsBody?.collisionBitMask = 0
        charaSprite.physicsBody?.contactTestBitMask = 1
        //上方向に力をかけてる。ゲーム開始直後に上にジャンプする。
        charaSprite.physicsBody?.velocity = CGVector(dx:0, dy:500)
        //重なり順の設定
        charaSprite.zPosition = 3
        self.addChild(charaSprite)
        
        //地面
        //名前を付ける
        floorSprite.name = "floor"
        //physicsBodyの設定
        floorSprite.physicsBody =  SKPhysicsBody(rectangleOf: CGSize(width: 640, height: 10))
        floorSprite.physicsBody?.collisionBitMask = 1
        floorSprite.physicsBody?.isDynamic = false
        floorSprite.position = CGPoint(x:0,y:40)
        //アンカーポイントの設定
        floorSprite.anchorPoint = CGPoint(x:0, y:0)
        //重なり順の設定
        floorSprite.zPosition = 4
        self.addChild(floorSprite)
        
        //上下の枠
        frameSprite.anchorPoint = CGPoint(x:0, y:0)
        self.addChild(frameSprite)
        frameSprite.zPosition = 5
        frameSprite.size = CGSize(width: screenWidth,
                                  height: screenHeight)
        
        //得点枠
        scoreFramesprite.anchorPoint =  CGPoint(x:1, y:1)
        scoreFramesprite.position = CGPoint(x:frameSprite.size.width - 10,y:frameSprite.size.height-10)
        scoreFramesprite.zPosition = 6
        self.addChild(scoreFramesprite)
        
        //得点ラベル
        pointLabel.text = "0里"
        pointLabel.fontSize = 20
        pointLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
        pointLabel.position = CGPoint(x:scoreFramesprite.position.x - 50, y:scoreFramesprite.position.y - 25)
        pointLabel.zPosition = 7
        self.addChild(pointLabel)
        
        //ハイスコアのラベル
        let highScorePoint = self.defaults.integer(forKey: "HIGHSCORE")
        highScoreLabel.text = "ハイスコア:\(highScorePoint)里"
        
        highScoreLabel.fontSize = 17
        highScoreLabel.fontColor = UIColor(red:1 , green: 1, blue: 1, alpha: 1)//白
        self.addChild(highScoreLabel)
        highScoreLabel.position = CGPoint(x:100, y:frameSprite.size.height-30)
        highScoreLabel.zPosition = 7
        
        //ゲームオーバー
        self.addChild(gameoverSprite)
        gameoverSprite.position = CGPoint(x:screenWidth * 0.5,
                                          y:screenHeight * 0.5)
        
        
        
        gameoverSprite.isHidden = true
        gameoverSprite.zPosition = 8
        
        //俳句を詠むときのスプライト
        self.addChild(haikuSprite)
        haikuSprite.zPosition = 9
        haikuSprite.position = CGPoint(x:50, y:100)
        haikuSprite.alpha = 0
    }
    
}
