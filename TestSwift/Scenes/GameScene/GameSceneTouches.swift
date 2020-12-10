//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.disksLayer)
        
        if let (row, column) = self.convertPointOnBoard(location) {
            // タップされた場所に現在のターンの石を配置する手
            let move = Move(color: self.nextColor,
                            row: row,
                            column: column - 1)
            
            if move.canPlace(self.board.cells) {
                self.makeMove(move)
                if self.board.hasGameFinished() == false {
                    self.switchTurnHandler?()
                }
            }
        }
    }
}
