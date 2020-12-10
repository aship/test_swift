//
//  GameScene.swift
//  ShrimpSwim
//
//  Created by 村田 知常 on 2015/12/28.
//  Copyright (c) 2015年 shoeisha. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let disksLayer = SKNode()
    
    var diskNodes = Array2D<SKSpriteNode>(rows: BoardSize, columns: BoardSize)
    var board: Board!
    var nextColor: CellState!
    
    let blackScoreLabel = SKLabelNode.createScoreLabel(x: 150, y: -260)
    let whiteScoreLabel = SKLabelNode.createScoreLabel(x: 150, y: -310)
    
    var gameResultLayer: SKNode?
    
    var switchTurnHandler: (() -> ())?
    
    var cpu: ComputerPlayer!
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }

    override func didMove(to view: SKView) {
        // 基準点を中心に設定
        //   super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // 背景の設定
        let background = SKSpriteNode(imageNamed: "background")
        //background.size = self.size
        background.size = CGSize(width: screenWidth,
                                 height: screenHeight)
        
        self.addChild(background)
        self.addChild(self.gameLayer)
        
        // anchorPointからの相対位置
        let layerPosition = CGPoint(
            x: -SquareWidth * CGFloat(BoardSize) / 2,
            y: -SquareHeight * CGFloat(BoardSize) / 2 + CentralDeltaY
        )
        
        self.gameLayer.addChild(self.blackScoreLabel)
        self.gameLayer.addChild(self.whiteScoreLabel)
        
        self.disksLayer.position = layerPosition
        self.gameLayer.addChild(self.disksLayer)
        
        
        
        let evaluate = countColor
        let maxDepth = 2
        let search = MiniMaxMethod(evaluate: evaluate, maxDepth: maxDepth)
        self.cpu = ComputerPlayer(color: .white, search: search)
        
        self.switchTurnHandler = self.switchTurn
        self.initBoard()
    }
}
