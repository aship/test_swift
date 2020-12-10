//
//  Enemy.swift
//  AkazukinDotEat
//
//  Created by Yoshitaka Yamashita on 2/8/15.
//  Copyright (c) 2015 Yoshitaka Yamashita. All rights reserved.
//

import Foundation
import SpriteKit

// 敵を表すクラス (キャラクターを継承)
class Enemy : Character {
    // 移動可能な方向を求めるメソッド
    func getMovableDirections() -> [Direction] {
        // 移動する可能性のある位置を全て取得する
        let positions = self.getPositions()
        // 移動可能な方向を格納する
        var directions = [Direction]()
        
        // 各方向について検証する
        for (position, direction) in positions {
            // 移動先のタイルを取得する
            let tile = self.delegate?.tileByPosition(position: position)
            if let tile = tile {
                // 移動先のタイルが移動可能であり、現在の進行方向と逆でなければ
                if tile.type.canMove() && direction != self.direction.reverseDirection() {
                    // 移動可能な方向として加える
                    directions.append(direction)
                }
            }
        }
        
        return directions
    }
    
    // 上下左右の移動先の位置を取得する
    func getPositions() -> [(TilePosition, Direction)] {
        return [
            (self.position.movedPosition(direction: .Up), .Up),
            (self.position.movedPosition(direction: .Down), .Down),
            (self.position.movedPosition(direction: .Left), .Left),
            (self.position.movedPosition(direction: .Right), .Right),
        ]
    }
    
    // moveメソッドをオーバライドする
    override func move() {
        // 移動したときの位置を求める
        let newPosition = self.position.movedPosition(direction: self.direction)
        // このまま移動可能かどうかを求める
        let canMove = self.canMove(position: newPosition)
        // 移動可能な方向を求める
        let directions = self.getMovableDirections()
        
        // 進行方向に移動出来ないか、移動可能な方向が複数ある場合
        if !canMove || directions.count >= 1 {
            // 方向をランダムに一つ選択する
            let index = Int(arc4random_uniform(UInt32(directions.count)))
            // 次回の移動方向として設定する
            self.nextDirection = directions[index]
            // 移動用タイマーを開始する
            self.startMoving()
        }
        
        // Characterクラスのmoveメソッドを呼ぶ
        super.move()
    }
}
