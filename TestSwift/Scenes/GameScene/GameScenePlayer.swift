//
//  GameScenePlayer.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    /// プレイヤーを構築
    func setupPlayer() {
        // Playerのパラパラアニメーション作成に必要なSKTextureクラスの配列を定義
        var playerTexture = [SKTexture]()
        
        // パラパラアニメーションに必要な画像を読み込む
        for imageName in Constants.PlayerImages {
            let texture = SKTexture(imageNamed: imageName)
            texture.filteringMode = .linear
            playerTexture.append(texture)
        }
        
        // キャラクターのアニメーションをパラパラ漫画のように切り替える
        let playerAnimation = SKAction.animate(with: playerTexture, timePerFrame: 0.2)
        // パラパラアニメーションをループさせる
        let loopAnimation = SKAction.repeatForever(playerAnimation)
        
        // キャラクターを生成
        player = SKSpriteNode(texture: playerTexture[0])
        // 初期表示位置を設定
        player.position = CGPoint(x: -100,
                                  y: 100)
        // アニメーションを設定
        player.run(loopAnimation)
        
        // 物理シミュレーションを設定
        player.physicsBody = SKPhysicsBody(texture: playerTexture[0], size: playerTexture[0].size())
        player.physicsBody?.isDynamic = false
        player.physicsBody?.allowsRotation = false
        
        // 自分自身にPlayerカテゴリを設定
        player.physicsBody?.categoryBitMask = ColliderType.Player
        // 衝突判定相手にWorldとCoralを設定
        player.physicsBody?.collisionBitMask = ColliderType.World | ColliderType.Coral
        player.physicsBody?.contactTestBitMask = ColliderType.World | ColliderType.Coral

        self.addChild(player)
    }
}
