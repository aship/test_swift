//
//  Tile.swift
//  AkazukinDotEat
//
//  Created by Yoshitaka Yamashita on 2/8/15.
//  Copyright (c) 2015 Yoshitaka Yamashita. All rights reserved.
//

import Foundation
import SpriteKit

// タイルの種類を表す列挙型
enum TileType: Int {
    case None
    // 通ることが出来る道
    case Road1, Road2, Road3, Road4, Road5, Road6, Road7, Road8, Road9, Road10, Road11
    // 障害物の木
    case Tree1, Tree2, Tree3
    
    // キャラクターが移動できる種類のタイルかどうかを返すメソッド
    func canMove() -> Bool {
        return (self != .None && self != .Tree1 && self != .Tree2 && self != .Tree3)
    }
}

// タイルを表すクラス
class Tile: SKSpriteNode {
    var type = TileType.None
}

// キャラクターが動く方向を表す列挙型
enum Direction {
    case None, Up, Down, Left, Right
    
    // 逆方向のDirectionを返却するメソッド
    func reverseDirection() -> Direction {
        switch self {
            case .None: return .None
            case .Up: return .Down
            case .Down: return .Up
            case .Left: return .Right
            case .Right: return .Left
        }
    }
}

// タイルの位置情報を表現する構造体
struct TilePosition {
    var x, y: Int
    
    // directionの方向に移動したときの位置を返すメソッド
    func movedPosition(direction:Direction) -> TilePosition {
        switch direction {
        case .Up: return TilePosition(x: x, y: y-1)
        case .Down: return TilePosition(x: x, y: y+1)
        case .Left: return TilePosition(x: x-1, y: y)
        case .Right: return TilePosition(x: x+1, y: y)
        case .None: return TilePosition(x: x, y: y)
        }
    }
    
    // 他のTilePositionと同じ位置かどうかを返すメソッド
    func isEqual(other:TilePosition) -> Bool {
        return self.x == other.x && self.y == other.y
    }
}