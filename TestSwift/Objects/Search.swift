
//
//  Search.swift
//  AppleReversi
//
//  Created by Tomochika Hara on 2015/02/22.
//  Copyright (c) 2015年 Tomochika Hara. All rights reserved.
//

import Foundation

/// 最小スコア
let MinScore = Int(UInt8.min)
/// 最大スコア
let MaxScore = Int(UInt8.max)

/// ゲーム木を探索して最良のスコアを求めるプロトコル
protocol Search {
    func getBestScore(_ board: Board, color: CellState) -> Int
}


/// 探索アルゴリズム実装のための基底クラス
class SearchAlgorithmBase {
    
    // 評価関数
    let evaluate: EvaluationFunction
    
    // 探索する深さ
    let maxDepth: Int
    
    init(evaluate: @escaping EvaluationFunction, maxDepth: Int) {
        self.evaluate = evaluate
        self.maxDepth = maxDepth
    }
}


/// MiniMax法による探索アルゴリズムの実装
class MiniMaxMethod : SearchAlgorithmBase, Search {
    
    func getBestScore(_ board: Board, color: CellState) -> Int {
        return self.miniMax(board, color: color, depth: 1)
    }
    
    func miniMax(_ node: Board, color: CellState, depth: Int) -> Int {
        if self.maxDepth <= depth {
            // 設定されている最大の深さに達したときに、評価値を算出
            return self.evaluate(node, color)
        }
        
        let moves = node.getValidMoves(color)
        
        if depth % 2 == 0 {
            // 対戦者のターン
            var worstScore = MaxScore
            
            // 対戦者が取れるすべての合法な手の中から、自分に取って最悪のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move)
                // 色を切り替えて、試行用のノードのスコアを取得、より悪いほうを選択
                let score = self.miniMax(testNode, color: color.opponent, depth: depth + 1)
                worstScore = min(worstScore, score)
            }
            return worstScore
        } else {
            // 自分のターン
            var bestScore = MinScore
            // 自身が取れるすべての合法な手の中から、自分に取って最良のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move)
                // 色を切り替えて、試行用のノードのスコアを取得、より良いほうを選択
                let score = self.miniMax(testNode, color: color.opponent, depth: depth + 1)
                bestScore = max(bestScore, score)
            }
            return bestScore
        }
    }
}

/// Alpha-Beta法による探索アルゴリズムの実装
class AlphaBetaPruning : SearchAlgorithmBase, Search {

    func getBestScore(_ board: Board, color: CellState) -> Int {
        return self.alphaBeta(board, color: color, depth: 1, α: MinScore, β: MaxScore)
    }

    func alphaBeta(_ node: Board, color: CellState, depth: Int, α: Int, β: Int) -> Int {
        var α = α, β = β

        if self.maxDepth <= depth {
            // 設定されている最大の深さに達したときに、評価値を算出
            return self.evaluate(node, color)
        }

        let moves = node.getValidMoves(color)

        if depth % 2 == 0 {
            // 対戦者のターン
            // 対戦者が取れるすべての合法な手の中から、自分に取って最悪のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move)
                // 色を切り替えて、試行用のノードのスコアを取得、より悪いほうを選択
                let score = self.alphaBeta(testNode, color: color.opponent, depth: depth + 1, α: α, β: β)
                β = min(β, score)
                if β <= α {
                    return β // βカット
                }
            }
            return β
        } else {
            // 自分のターン
            // 自身が取れるすべての合法な手の中から、自分に取って最良のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move)
                // 色を切り替えて、試行用のノードのスコアを取得、より良いほうを選択
                let score = self.alphaBeta(testNode, color: color.opponent, depth: depth + 1, α: α, β: β)
                α = max(α, score)
                if β <= α {
                    return α // αカット
                }
            }
            return α
        }
    }
}
