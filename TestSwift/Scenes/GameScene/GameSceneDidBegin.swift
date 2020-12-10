//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/10/26.
//

import SpriteKit

extension GameScene {
    //ここで加点・ジャンプ・ゲームオーバーの判定をしています
    func didBegin(_ contact: SKPhysicsContact) {
        //contactFlgがtrue（芭蕉が落下中）の時のみ実行する
        if(contactFlg == true){
            //0.5秒でy座標を100　nodeを下方向に移動する
            let moveA = SKAction.move(by: CGVector(dx:0, dy:-100),
                                      duration: 0.5)
            blocksNode.run(moveA)
            charaSprite.physicsBody?.velocity = CGVector(dx:0,
                                                         dy:300)
            
            //床に衝突したらゲームオーバー、ブロックと衝突したらジャンプ
            if( contact.bodyA.node?.name == "floor" || contact.bodyB.node?.name == "floor"  ){
                print("ゲームオーバー")
                gameoverSprite.isHidden = false
                self.gameover()
            }else{
                //ポイントを加算してラベルに表示
                point = point + 1
                pointLabel.text =  "\(point)里"
                
                //20里毎に俳句を表示する。俳句の画像の種類は200里までなので200以下の条件も追加する
                if(point%20 == 0 && point <= 200){
                    self.showHaiku(point: point)
                }
            }
            
            //ジャンプするときのアニメーション
            let changeTexture = SKAction.animate(with: [SKTexture(imageNamed: "up"),
                                                        SKTexture(imageNamed: "down")],
                                                 timePerFrame: 0.2)
            charaSprite.run(changeTexture)
        }
    }
    
    
    func showHaiku(point:Int)
    {
        //フェードイン
        let alphaAction = SKAction.fadeAlpha(to: 1, duration: 0.5)
        //５秒間待ち
        let delayAction = SKAction.wait(forDuration: 5)
        //フェードアウト
        let alphaAction2 = SKAction.fadeAlpha(to: 0, duration: 0.5)
        //フェードと待ちのアクションの順番を設定
        let sequenceAction = SKAction.sequence([alphaAction,delayAction,alphaAction2])
        //リピート回数は1回
        let repeatAction = SKAction.repeat(sequenceAction, count: 1)
        
        //俳句の画像を切り替え
        haikuSprite.texture = SKTexture(imageNamed:"paper\(point)")
        
        //アクション実行
        haikuSprite.run(repeatAction)
    }
    
    
    
    func gameover()
    {
        //ゲームオーバーフラグ
        gameoverFlg = true
        
        //一時停止
        self.isPaused = true
        
        //キャラクタの画像を失敗用の画像に差し替える
        charaSprite.texture = SKTexture(imageNamed: "miss")
        
        //ハイスコアを記録
        self.highScore()
        
    }
    
    func highScore() {
        //NSUserDefaultsで保存したハイスコアを読み込む
        let highscore:Int = defaults.integer(forKey: "HIGHSCORE")
        
        //今回の得点がハイスコアよりも大きければ、今回の得点を保存する
        if(point > highscore ){
            //HIGHSCOREという名前でint型でpointを保存する
            defaults.set(point, forKey:"HIGHSCORE")
            //保存した値を反映する
            defaults.synchronize()
            //ハイスコアをラベルに表示する
            highScoreLabel.text = NSString(format: "ハイスコア：%d里",self.defaults.integer(forKey: "HIGHSCORE")) as String
        }
    }
}
