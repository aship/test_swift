//
//  ComputerPlayer.swift
//  AppleReversi
//
//  Created by Tomochika Hara on 2015/02/22.
//  Copyright (c) 2015年 Tomochika Hara. All rights reserved.
//

import Foundation

/// コンピュータプレイヤー
class ComputerPlayer {

    let color: CellState
    let search: Search

    init(color: CellState, search: Search) {
        self.color = color
        self.search = search
    }

    /// 手を選択する
    func selectMove(_ board: Board) -> Move? {

        var bestMove: Move?
        var bestScore = MinScore

        // 最良の手を探索
        let moves = board.getValidMoves(self.color)
        for nextMove in moves {
            let test = board.clone()
            test.makeMove(nextMove)

            let score = self.search.getBestScore(test, color: self.color)

            if bestScore <= score {
                bestScore = score
                bestMove = nextMove
            }
        }

        return bestMove
    }
}
