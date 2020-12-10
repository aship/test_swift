//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    /// リザルト画面を表示する
    func showGameResult() {
        let black = self.board.countCells(.black)
        let white = self.board.countCells(.white)
        // 勝敗に対応した画像を読み込んだノード
        var resultImage: SKSpriteNode
        if white < black {
            resultImage = SKSpriteNode(imageNamed: "win_black")
        } else if (black < white) {
            resultImage = SKSpriteNode(imageNamed: "win_white")
        } else {
            resultImage = SKSpriteNode(imageNamed: "draw")
        }
        // 画像の縦幅の調整
        let sizeRatio = self.size.width / resultImage.size.width
        let imageHeight = resultImage.size.height * sizeRatio
        resultImage.size = CGSize(width: self.size.width, height: imageHeight)
        
        let gameResultLayer = GameResultLayer()
        gameResultLayer.isUserInteractionEnabled = true
        gameResultLayer.touchHandler = self.hideGameResult
        gameResultLayer.addChild(resultImage)
        
        self.gameResultLayer = gameResultLayer
        self.addChild(self.gameResultLayer!)
    }
    
    /// リザルト画面を非表示にする
    func hideGameResult() {
        self.gameResultLayer?.removeFromParent()
        self.gameResultLayer = nil
        self.restartGame()
    }
}
