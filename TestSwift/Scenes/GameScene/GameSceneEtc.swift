//
//  GameSceneLayout.swift
//  TestSwift
//
//  Created by aship on 2020/11/07.
//

import SpriteKit

extension GameScene {
    
    // インデックスからタイルを求めるメソッド
    func getTilePositionByIndex(index:Int) -> TilePosition {
        return TilePosition(x: index % self.mapWidth, y: index / self.mapWidth)
    }
    
    // タイルの位置からシーン上での位置を返すメソッド
    func getPointByTilePosition(position:TilePosition) -> CGPoint {
        let x = CGFloat(position.x + 1) * self.tileSize.width
        let y = screenHeight - CGFloat(position.y + 1) * self.tileSize.height
        
        return CGPoint(x: x, y: y)
    }
    
    // キャラクターが移動したときに呼ばれるメソッド
    func moveCharacter(character: Character) {
        // スプライトに移動アニメーションを適用する
        if let sprite = character.sprite {
            let moveAction = SKAction.move(to: self.getPointByTilePosition(position: character.position),
                                           duration: 0.6)
            sprite.run(moveAction)
        }
        
        if let player = self.player {
            // 全ての敵に対して処理を行う
            for enemy in self.enemies {
                // プレイヤーと敵が同じ位置にいたら
                if player.position.isEqual(other: enemy.position) {
                    // ゲームオーバー画面のシーンを作成する
                    let scene = self.createImageScene(imageName: "gameover")
                    // クロスフェードトランジションを適用しながらシーンを移動する
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    self.view?.presentScene(scene,
                                            transition: transition)
                    
                    // プレイヤーの動きを止める
                    player.stopMoving()
                    // 全ての敵の動きを止める
                    for e in self.enemies {
                        e.stopMoving()
                    }
                    break
                }
            }
        }
    }
    
    // 指定位置のタイルを返すメソッド
    func tileByPosition(position: TilePosition) -> Tile? {
        // タイルの位置からインデックスを求める
        let index = position.y * self.mapWidth + position.x
        // インデックスがマップの範囲外ならnilを返す
        if position.x < 0 || position.y < 0 || position.x >= self.mapWidth || position.y >= self.mapHeight {
            return nil
        }
        // インデックスからタイルを返却する
        return self.tileMap[index]
    }
    
    // 花を摘むときに呼ばれるメソッド
    func removeFlower(position: TilePosition) {
        // タイルの位置からインデックスを求める
        let index = position.y * self.mapWidth + position.x
        // インデックスから花のスプライトを求める
        if let flowerSprite = self.flowerMap[index] {
            // スプライトをシーンから削除する
            flowerSprite.removeFromParent()
            // 辞書からも削除する
            self.flowerMap.removeValue(forKey: index)
            
            // スコアを加算する
            self.score = self.score + 1
            // スコアラベルを更新する
            self.scoreLabel?.text = "\(self.score)"
            
            // 全ての花を摘み終えたら
            if self.flowerMap.count == 0 {
                // ゲームクリア画面のシーンを作成する
                let scene = self.createImageScene(imageName: "gameclear")
                // クロスフェードトランジションを適用しながらシーンを移動する
                let transition = SKTransition.crossFade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
                
                // プレイヤーの動きを止める
                self.player?.stopMoving()
                // 全ての敵の動きを止める
                for enemy in self.enemies {
                    enemy.stopMoving()
                }
            }
        }
    }
    
    // 一枚絵を表示するシーンを作成するメソッド
    func createImageScene(imageName: String) -> SKScene {
        // シーンのサイズはGameSceneに合わせる
        let scene = TouchScene(size: CGSize(width: screenWidth,
                                            height: screenHeight))
        
        // スプライトをシーン中央に貼り付ける
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = scene.size
        sprite.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scene.addChild(sprite)
        
        return scene
    }
}
