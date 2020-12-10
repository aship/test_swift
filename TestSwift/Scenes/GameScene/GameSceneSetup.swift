//
//  GameSceneSetup.swift
//  TestSwift
//
//  Created by aship on 2020/11/07.
//

import SpriteKit

extension GameScene {
    /// 盤の初期化
    func initBoard() {
        self.board = Board()
        self.updateDiskNodes()
        self.nextColor = .black
    }
    
    /// 手を打つ
    func makeMove(_ move: Move?) {
        if move != nil {
            // 盤上に手を打つ
            self.board.makeMove(move!)
        }
        // 今打った手とは反対の色にターンを変える
        self.nextColor = self.nextColor.opponent
        // 今打った石と返された石を画面上に表示
        self.updateDiskNodes()
        if self.board.hasGameFinished() {
            // ゲーム終了時
            self.showGameResult()
        }
    }
    
    func switchTurn() {
        if self.nextColor == self.cpu.color {
            //  self.isUserInteractionEnabled = false
            Timer.scheduledTimer(timeInterval: 0.3,
                                 target: self,
                                 selector: #selector(self.makeMoveByComputer),
                                 userInfo: nil,
                                 repeats: false)
        }
    }
    
    /// コンピュータプレイヤーに一手打たせる
    @objc func makeMoveByComputer() {
        let nextMove = self.cpu.selectMove(self.board!)
        self.makeMove(nextMove)
        
        // プレイヤーが合法な手を打てない場合は、プレイヤーのターンをスキップする
        if self.board.hasGameFinished() == false &&
            self.board.existsValidMove(self.cpu.color.opponent) == false {
            self.makeMoveByComputer()
        }
        //  self.isUserInteractionEnabled = true
    }
    
    
    func updateDiskNodes() {
        
        for (row, column, state) in self.board.cells {
            
            if let imageName = DiskImageNames[state] {
                if let prevNode = self.diskNodes[row, column] {
                    if prevNode.userData?["state"] as! Int == state.rawValue {
                        // 変化が無いセルはスキップする
                        continue
                    }
                    // 古いノードを削除
                    prevNode.removeFromParent()
                }
                
                // 新しいノードをレイヤーに追加
                let newNode = SKSpriteNode(imageNamed: imageName)
                newNode.userData = ["state" : state.rawValue] as NSMutableDictionary
                
                newNode.size = CGSize(width: SquareWidth, height: SquareHeight)
                newNode.position = self.convertPointOnLayer(row, column: column)
                self.disksLayer.addChild(newNode)
                
                self.diskNodes[row, column] = newNode
            }
        }
        // スコア表示の更新
        self.updateScores()
    }
    
    /// ゲームをリスタートする
    func restartGame() {
        for (row, column, diskNode) in self.diskNodes {
            diskNode.removeFromParent()
            self.diskNodes[row, column] = nil
        }
        self.initBoard()
    }
    
    /// 盤上での座標をレイヤー上での座標に変換する
    func convertPointOnLayer(_ row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * SquareWidth + SquareWidth / 2,
            y: CGFloat(row) * SquareHeight + SquareHeight / 2
        )
    }
    
    /// レイヤー上での座標を盤上での座標に変換する
    func convertPointOnBoard(_ point: CGPoint) -> (row: Int, column: Int)? {
        print("point.x \(point.x)")
        print("point.y \(point.y)")
        
        if 0 <= point.x && point.x < SquareWidth * CGFloat(BoardSize) &&
            0 <= point.y && point.y < SquareHeight * CGFloat(BoardSize) {
            
            print("xxxx \(Int(point.y / SquareHeight))")
            print("yyyy \(Int(point.x / SquareWidth))")
            
            return (Int(point.y / SquareHeight), Int(point.x / SquareWidth))
        } else {
            return nil
        }
    }
    
    /// スコアを更新する
    func updateScores() {
        self.blackScoreLabel.text = String(self.board.countCells(.black))
        self.whiteScoreLabel.text = String(self.board.countCells(.white))
    }
}

