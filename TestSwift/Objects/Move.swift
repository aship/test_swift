//
//  Move.swift
//  AppleReversi
//
//  Created by Tomochika Hara on 2015/02/22.
//  Copyright (c) 2015年 Tomochika Hara. All rights reserved.
//

import Foundation

/// 一直線上の方向
enum Line: Int {
    case backward = -1, hold, forward
    static let allValues: [Line] = [.backward, .hold, .forward]
}

/// 盤面上での石を返す方向
typealias Direction = (vertical: Line, horizontal: Line)


/// 盤上の位置にどちらの石を置くかを表わす「手」
class Move {
    // この手で配置する石の色
    let color: CellState
    // 配置する座標の行番号
    let row: Int
    // 配置する座標の列番号
    let column: Int
    
    init(color: CellState, row: Int, column: Int) {
        self.color = color
        self.row = row
        self.column = column
    }
    
    /// この手の座標から見て、引数で渡されたDirectionの方向で裏返すことができる石の数を返す
    func countFlippableDisks(_ direction: Direction, cells: Array2D<CellState>) -> Int {
    
        // 垂直方向の進行方向を表わす係数
        let y = direction.vertical.rawValue
    
        // 水平方向の進行方向を表わす係数
        let x = direction.horizontal.rawValue
    
        // 相手の色
        let opponent = self.color.opponent
    
        // 指定された方向に相手の色が続いている数
        var count = 1
    
        while (cells[self.row + count * y, self.column + count * x] == opponent) {
                count += 1
        }
    
        // 相手の色が続いた後のセルが自分の色である場合は、正常に裏返すことができる
        if cells[self.row + count * y, self.column + count * x] == self.color {
            return count - 1
        } else {
            return 0
        }
    }

    /// 指定された場所に石を置ける場合、trueを返す
    func canPlace(_ cells: Array2D<CellState>) -> Bool {
        if let state = cells[self.row, self.column] {
            if state != .empty { // すでに石が置かれている
                return false
            }
        }

        for vertical in Line.allValues {
            for horizontal in Line.allValues {
                if vertical == .hold && horizontal == .hold {
                    continue
                }
                if 0 < self.countFlippableDisks((vertical, horizontal), cells: cells) {
                    return true
                }
            }
        }

        // 全方向に裏返せる石が無い
        return false
    }
}
