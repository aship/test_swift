//
//  Evaluation.swift
//  AppleReversi
//
//  Created by Tomochika Hara on 2015/02/22.
//  Copyright (c) 2015年 Tomochika Hara. All rights reserved.
//

import Foundation

/// 評価関数の型
typealias EvaluationFunction = (_ board: Board, _ color: CellState) -> Int

/// 盤上の色の数のみを評価値とする評価関数
func countColor(_ board: Board, color: CellState) -> Int {
    return board.countCells(color)
}

/// 盤上の位置に付けられた評価値の合計を評価値とする評価関数
func getWeightedScore(_ board: Board, color: CellState) -> Int {
    let opponent = color.opponent

    var total = 0
    for row in 0..<BoardSize {
        for column in 0..<BoardSize {
            if let state = board.cells[row, column] {
                if state == color {
                    total += CellWeights[row][column]
                } else if state == opponent {
                    total -= CellWeights[row][column]
                }
            }
        }
    }
    return total
}

let CellWeights = [
    [120, -20, 20, 5, 5, 20, -20, 120],
    [-20, -40, -5, -5, -5, -5, -40, -20],
    [ 20, -5, 15, 3, 3, 15, -5, 20],
    [ 5, -5, 3, 3, 3, 3, -5, 5],
    [ 5, -5, 3, 3, 3, 3, -5, 5],
    [ 20, -5, 15, 3, 3, 15, -5, 20],
    [-20, -40, -5, -5, -5, -5, -40, -20],
    [120, -20, 20, 5, 5, 20, -20, 120],
]

