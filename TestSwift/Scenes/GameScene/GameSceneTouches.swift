//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            _ = touch.location(in: self)
            
            //アームを上げる
            let swingAction1 = SKAction.rotate(byAngle: CGFloat(-Double.pi * 0.25), duration:0.05)
            let swingAction2 = SKAction.rotate(byAngle: CGFloat(Double.pi * 0.25), duration:0.05)
            armRight.run(swingAction1)
            armLeft.run(swingAction2)
        }
        
        //ゲームオーバーだったらスタート位置に戻す
        if gameoverFlg == true {
            self.reset()
        }
    }
    
    func reset(){
        //ゲームオーバーフラグをもどす
        gameoverFlg = false
        
        //ゲームオーバーラベルを削除
        gameoverLabel.removeFromParent()
        
        //ボールを削除して作り直す
        ball.removeFromParent()
        self.makeBall()
        
        //得点を0にもどす
        count = 0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            _ = touch.location(in: self)
            
            //アームを下げる
            let swingAction1 = SKAction.rotate(byAngle: CGFloat(-Double.pi * 0.25),
                                               duration:0.05)
            let swingAction2 = SKAction.rotate(byAngle: CGFloat(Double.pi * 0.25),
                                               duration:0.05)
            armRight.run(swingAction2)
            armLeft.run(swingAction1)
        }
    }
}
