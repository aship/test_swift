//
//  GameSceneTouches.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        //    print("TPCUH BEGIN")
        
        if _gameOver {
            //タッチ通知
            //            if _gameDelegate.responds(to: "sceneEscape:") {
            //                _gameDelegate.sceneEscape(self)
            //            }
        } else {
            for touch: AnyObject in touches {
                _touchPoint = touch.location(in: self)
                _acceleON = true
            }
        }
    }
    
    //タッチムーブ
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        //   print("TPCUH MVOED")
        
        
        if _gameOver == false {
            for touch: AnyObject in touches {
                let location = touch.location(in: self)
                
                
                
                let len: CGFloat = abs(_touchPoint.x-location.x)
                let factor: CGFloat = (len/80) > 1.0 ? 1.0 : (len/80)
                var angle: CGFloat = 0
                
                //最大２５度回転
                if _touchPoint.x - location.x > 0 {
                    angle = CGFloat(Double.pi / 180 * 25) * factor
                    //左
                } else {
                    angle = CGFloat(-1 * Double.pi / 180 * 25) * factor
                    //右
                    
                }
                
                //プレイヤーカーを検索
                let road: SKNode = self.childNode(withName: kRoadName)!
                let playerCar: SKSpriteNode = ((road.childNode(withName: kPlayerCarName) as? SKSpriteNode)!)
                playerCar.zRotation = angle
                
            }
            
            
            
        }
    }
    
    //タッチアップ
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        //フラグを下ろす
        _acceleON = false
    }
}
