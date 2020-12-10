//
//  GameSceneLabel.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        charaSprite.position = CGPoint(x: charaSprite.position.x + CGFloat(self.charaXposition),
                                       y: charaSprite.position.y)
        
        //画面の外に出たら、反対側に移動
        if(charaSprite.position.x < 0){
            charaSprite.position.x = 320
        }else if(charaSprite.position.x > 320){
            charaSprite.position.x = 0
        }
        
        //下がっていたらぶつかる。あがっていたらぶつからない。
        if(charaSprite.position.y < charaYpos){
            //ぶつかる
            contactFlg = true
            charaSprite.physicsBody?.collisionBitMask = 1
            charaSprite.physicsBody?.contactTestBitMask = 1
        }else{
            //ぶつからない
            contactFlg = false
            charaSprite.physicsBody?.collisionBitMask = 0
            charaSprite.physicsBody?.contactTestBitMask = 0
        }
        charaYpos = charaSprite.position.y
    }
}
