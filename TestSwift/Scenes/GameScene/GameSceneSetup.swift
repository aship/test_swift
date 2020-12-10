//
//  GameSceneSetup.swift
//  TestSwift
//
//  Created by aship on 2020/11/07.
//

import SpriteKit

extension GameScene {
    // マップを描画するメソッド
    func drawMap() {
        // CSVファイルのパスを求める
        if let fileName = Bundle.main.path(forResource: "map", ofType: "csv") {
            // マップを読み込む
            self.loadMapData(fileName: fileName)
        }
        
        // タイルのスプライトをシーンに貼り付ける
        for tile in self.tileMap {
            self.addChild(tile)
        }
        
        // 花のスプライトをシーンに貼り付ける
        for (_, flowerSprite) in self.flowerMap {
            self.addChild(flowerSprite)
        }
    }
    
    // マップデータを読み込むメソッド
    func loadMapData(fileName:String) {
        // ファイルをUTF-8エンコードの文字列として読み込む
        let fileString: String
        do {
            fileString = try String(contentsOfFile: fileName,
                                    encoding: String.Encoding.utf8)
        }
        catch {
            return
        }

        // 改行で区切って配列にする
        let lineList = fileString.components(separatedBy: "\n")
        // 配列の要素数(CSVファイルの行数)を縦方向のタイル数として保持
        self.mapHeight = lineList.count
        
        // 配列のインデックス
        var index = 0

        // 行ごとに処理を行う
        for line in lineList {
            // カンマで要素を分割する
            let tileStringList = line.components(separatedBy: ",")
            
            if self.mapWidth == 0 {
                // 配列の要素数を横方向のタイル数として保持
                self.mapWidth = tileStringList.count
                // タイルの幅を求める
                let tileWidth = Double(screenWidth) * 0.9 / Double(self.mapWidth)
                // タイルの大きさを控える
                self.tileSize = CGSize(width: tileWidth,
                                       height: tileWidth)
            }
            
            // 行中の要素ごとに処理を行う
            for tileString in tileStringList {
                // 文字列をInt型に変換する
                let value = Int(tileString)
                // Int型の値をTileType型に変換する
                if let type = TileType(rawValue: value!) {
                    // インデックスからタイルの位置を求める
                    let position = self.getTilePositionByIndex(index: index)
                    
                    // タイルを作成して配列に納める
                    let tile = Tile(imageNamed: tileString)
                    tile.position = self.getPointByTilePosition(position: position)
                    tile.size = self.tileSize
                    tile.type = type
                    self.tileMap.append(tile)
                    
                    // タイルが花を置く条件にあてはまる場合
                    if type == .Road1 || type == .Road2 {
                        // 花のスプライトを作成して配列に納める
                        let flowerSprite = SKSpriteNode(imageNamed: "flower")
                        flowerSprite.size = tile.size
                        flowerSprite.position = tile.position
                        flowerSprite.anchorPoint = tile.anchorPoint
                        self.flowerMap[index] = flowerSprite
                    }
                }
                
                index = index + 1
            }
        }
    }
    
    
    // プレイヤー(赤ずきん)を作成するメソッド
    func createPlayer(firstPosition:TilePosition) {
        // テクスチャを二枚用意する
        let akazukin1 = SKTexture(imageNamed: "akazukin01")
        let akazukin2 = SKTexture(imageNamed: "akazukin02")
        
        // 一枚目のテクスチャでスプライトを作成する
        let sprite = SKSpriteNode(texture: akazukin1)
        sprite.size = CGSize(width: self.tileSize.width, height: self.tileSize.height)
        sprite.position = self.getPointByTilePosition(position: firstPosition)
        self.addChild(sprite)
        
        // 二枚のテクスチャでアニメーションを行う
        let animation = SKAction.animate(with: [akazukin1, akazukin2], timePerFrame: 0.5)
        let repeatAction = SKAction.repeatForever(animation)
        sprite.run(repeatAction)
        
        // Playerクラスのオブジェクトを作成する
        let player = Player()
        player.delegate = self              // デリゲートにGameSceneを指定する
        player.position = firstPosition
        player.sprite = sprite
        player.startMoving()                // 移動を開始する
        self.player = player
    }
    
    // 敵(オオカミ)を作成するメソッド
    func createEnemy(firstPosition:TilePosition) {
        // テクスチャを二枚用意する
        let wolf1 = SKTexture(imageNamed: "wolf01")
        let wolf2 = SKTexture(imageNamed: "wolf02")
        
        // 一枚目のテクスチャでスプライトを作成する
        let sprite = SKSpriteNode(texture: wolf1)
        sprite.size = CGSize(width: self.tileSize.width * 1.5,
                             height: self.tileSize.height)    // タイルから少しはみ出るくらい横幅を確保する
        sprite.position = self.getPointByTilePosition(position: firstPosition)
        self.addChild(sprite)
        
        // 二枚のテクスチャでアニメーションを行う
        let animation = SKAction.animate(with: [wolf1, wolf2], timePerFrame: 0.5)
        let repeatAction = SKAction.repeatForever(animation)
        sprite.run(repeatAction)
        
        // Enemyクラスのオブジェクトを作成する
        let enemy = Enemy()
        enemy.delegate = self               // デリゲートにGameSceneを指定する
        enemy.position = firstPosition
        enemy.sprite = sprite
        // 移動を開始する
        enemy.startMoving()
        
        self.enemies.append(enemy)
    }
}

