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
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            _ = touch.location(in: self)
            
            //ゲームオーバーの時に画面をタップしたらゲームを再スタート
            if gameoverFlg == true {
                //得点をリセット
                point = 0
                
                //blocksNode上のブロックを削除
                blocksNode.removeAllChildren()
                
                //blocksNodeを削除
                blocksNode.removeFromParent()
                
                //全部のオブジェクトを削除
                self.removeAllChildren()
                
                //オブジェクトを配置し直す
                self.layoutObjects()
                
                //ゲームオーバーフラグを下げる
                gameoverFlg = false
                
                //再開
                self.isPaused = false
                
                //テクスチャをセット
                charaSprite.texture = SKTexture(imageNamed: "up")
            }
        }
        
    }
}
