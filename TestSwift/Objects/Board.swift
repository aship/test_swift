//
//  Board.swift
//  AppleReversi
//
//  Created by Tomochika Hara on 2015/02/22.
//  Copyright (c) 2015年 Tomochika Hara. All rights reserved.
//

import Foundation

/// 盤の一辺のセルの数
let BoardSize = 8

/// 8 * 8 の盤面
class Board : CustomStringConvertible {
    
    /// 盤上のすべてのセルの状態を保持する二次元配列
    var cells: Array2D<CellState>
    
    /// イニシャライザ
    init() {
        self.cells = Array2D<CellState>(rows: BoardSize, columns: BoardSize, repeatedValue: .empty)
        self.cells[3, 3] = .black
        self.cells[4, 2] = .black
        self.cells[3, 2] = .white
        self.cells[4, 3] = .white
    }
    
    init(cells: Array2D<CellState>) {
        self.cells = cells
    }
    
    func clone() -> Board {
        return Board(cells: self.cells)
    }
    
    /// 手を打つ
    func makeMove(_ move: Move) {
        for vertical in Line.allValues {
            for horizontal in Line.allValues {
                if vertical == .hold && horizontal == .hold {
                    continue
                }
                let direction = (vertical, horizontal)
                let count = move.countFlippableDisks(direction, cells: self.cells)
        
                if 0 < count {
                    // 石を返す
                    let y = vertical.rawValue
                    let x = horizontal.rawValue
                    for i in 1...count {
                        self.cells[move.row + i * y, move.column + i * x] = move.color
                    }
                }
            }
        }
        
        // 石を置く
        self.cells[move.row, move.column] = move.color
    }

    /// 指定された状態のセルの数を返す
    func countCells(_ state: CellState) -> Int {
        var count = 0
        for row in 0..<self.cells.rows {
            for column in 0..<self.cells.columns {
                if self.cells[row, column] == state {
                    count += 1
                }
            }
        }
        return count
    }
    
    /// ゲームが終了した場合、trueを返す
    func hasGameFinished() -> Bool {
        return self.existsValidMove(.black) == false && self.existsValidMove(.white) == false
    }

    /// 合法な手が存在する場合、trueを返す
    func existsValidMove(_ color: CellState) -> Bool {
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                let move = Move(color: color, row: row, column: column)
                if move.canPlace(self.cells) {
                    return true
                }
            }
        }
        return false
    }
    
    // 指定された色の合法な手の一覧を返す
    func getValidMoves(_ color: CellState) -> [Move] {
        var moves = Array<Move>()
        
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                let move = Move(color:color, row: row, column: column)
                if move.canPlace(self.cells) {
                    moves.append(move)
                }
            }
        }
        
        return moves
    }
    
    var description: String {
        var rows = Array<String>()
        for row in 0..<BoardSize {
            var cells = Array<String>()
            for column in 0..<BoardSize {
                if let state = self.cells[row, column] {
                    cells.append(String(state.rawValue))
                }
            }
            let line = cells.joined(separator: " ")
            rows.append(line)
        }
        return Array(rows.reversed()).joined(separator: "\n")
    }
}
