//
//  GameSceneCoral.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    
    ///  障害物のサンゴを構築
    func setupCoral() {
        // サンゴ画像を読み込み
        let coralUnder = SKTexture(imageNamed: "coral_under")
        coralUnder.filteringMode = .linear
        
        let coralAbove = SKTexture(imageNamed: "coral_above")
        coralAbove.filteringMode = .linear
        
        // 移動する距離を算出
        let distanceToMove = CGFloat(screenWidth + 2.0 * coralUnder.size().width)
        
        // 画面外まで移動するアニメーションを作成
        let moveAnim = SKAction.moveBy(x: -distanceToMove,
                                       y: 0.0,
                                       duration:TimeInterval(distanceToMove / 100.0))
        // 自身を取り除くアニメーションを作成
        let removeAnim = SKAction.removeFromParent()
        // 2つのアニメーションを順に実行するアニメーションを作成
        let coralAnim = SKAction.sequence([moveAnim, removeAnim])
        
        // サンゴを生成するメソッドを呼び出すアニメーションを作成
        let newCoralAnim = createCoralAction(coralUnder: coralUnder,
                                             coralAbove: coralAbove,
                                             coralAnim: coralAnim)
        // 一定間隔待つアニメーションを作成
     //   let delayAnim = SKAction.wait(forDuration: 2.5)
        let delayAnim = SKAction.wait(forDuration: 3.5)
       
        
        // 上記2つを永遠と繰り返すアニメーションを作成
        let repeatAction = SKAction.sequence([newCoralAnim, delayAnim])
        let repeatForeverAnim = SKAction.repeatForever(repeatAction)
        
        // この画面で実行
        self.run(repeatForeverAnim)
    }
    
    func createCoralAction(coralUnder: SKTexture,
                           coralAbove: SKTexture,
                           coralAnim: SKAction) -> SKAction {
        let action = SKAction.run({
            // サンゴに関するノードを乗せるノードを作成
            let coral = SKNode()
            coral.position = CGPoint(x: self.screenWidth / 2 + coralUnder.size().width * 2,
                                     y: 0.0)
    
        //    coral.position = CGPoint(x: 0.0,
          //                           y: 0.0)
            
            coral.zPosition = -40.0
            
            // 地面から伸びるサンゴのy座標を算出
          //  let height = UInt32(self.screenHeight / 12)
        //    let y = CGFloat(arc4random_uniform(height * 2) + height)
            
            // 地面から伸びるサンゴを作成
            let under = SKSpriteNode(texture: coralUnder)
            under.position = CGPoint(x: 0.0,
                                     y: -400.0 + Double(arc4random_uniform(140)))
                                     //y: y - 500)
            
            // サンゴに物理シミュレーションを設定
            under.physicsBody = SKPhysicsBody(texture: coralUnder, size: under.size)
            under.physicsBody?.isDynamic = false
            under.physicsBody?.categoryBitMask = ColliderType.Coral
            under.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(under)
            
            
            
            
            // 天井から伸びるサンゴを作成
            let above = SKSpriteNode(texture: coralAbove)
            
         //   let yPos = y + (under.size.height / 2.0) + 160.0 + (above.size.height / 2.0)
            //let yPos = 300.0
            
            above.position = CGPoint(x: 0.0,
                                     y: 400.0 - Double(arc4random_uniform(140)))
                                     // y: yPos)
            
            // ¡サンゴに物理シミュレーションを設定
            above.physicsBody = SKPhysicsBody(texture: coralAbove, size: above.size)
            above.physicsBody?.isDynamic = false
            above.physicsBody?.categoryBitMask = ColliderType.Coral
            above.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(above)
            
            
            
            
            
            
            // スコアをカウントアップするノードを作成
            let scoreNode = SKNode()
            scoreNode.position = CGPoint(x: (above.size.width / 2.0) + 5.0,
                                         y: 0)
            
            // スコアノードに物理シミュレーションを設定
            scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0,
                                                                      height: self.screenHeight))
            scoreNode.physicsBody?.isDynamic = false
            scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
            scoreNode.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(scoreNode)
            coral.run(coralAnim)
            
            self.coralNode.addChild(coral)
        })
        
        return action
    }
}
