//
//  GameSceneShoot.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    //コントローラ射撃アニメーション
    func shootAnimation() {
        self.shootOK = false    //射撃フラグOFF
        //（１）弓を弾くアニメーション
        let bowActions = [    //縦のスケール値を変更
            SKAction.scaleX(to: 1.0, y: 0.2, duration: 0.05),
            //縦のスケール値を変更
            SKAction.scaleX(to: 1.0, y: 1.0, duration: 0.05)]
        self.cntBowNode.run(SKAction.sequence(bowActions))
        
        //（２）矢の射撃と再装填のアニメーション
        let arrowActions = [//SE再生
            SKAction.playSoundFileNamed("se_shot1.m4a", waitForCompletion: false),
            //y方向に移動
            SKAction.moveBy(x: 0.0, y: 800, duration: 0.1),
            SKAction.wait(forDuration: self.playerNode.reloadDelay),    //再装填遅延時間
            //45度回転させて、y方向に移動
            SKAction.rotate(toAngle: CGFloat(Double.pi  / 4), duration: 0),
            SKAction.move(to: CGPoint(x: 0, y: -100), duration: 0),
            //元の位置に戻す
            SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1),
            //元の角度に戻す
            SKAction.rotate(toAngle: 0, duration: 0.05),
            SKAction.run({ () -> Void in
                self.shootOK = true    //射撃フラグON
            })]
        self.cntArrowNode.run(SKAction.sequence(arrowActions))
    }
    
    // 矢を射撃する
    func shootArrow(_ position: CGPoint) {
        if self.haveArrows <= 0 {
            //矢がない
            return
        }
        //矢作成
        let name = "arrow"
        let arrow = SKSpriteNode(imageNamed: name)        //矢のスプライトを作成
        self.baseNode.addChild(arrow)                    //baseNodeに配置する
        arrow.name = NodeName.arrow.rawValue            //列挙型で名前を設定する
        arrow.position = position                        //指定位置に配置
        arrow.zRotation = self.shootRadian                //角度設定
        arrow.zPosition = NodeName.arrow.zPosition()
        arrow.userData = ["drawingBow":self.drawingBow]
        //物理設定
        let size = arrow.size
        //矢の横幅を直径とする円形の物理体を作成する
        arrow.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2, center: CGPoint(x: 0, y: 0))
        //当たり用の設定
        arrow.physicsBody!.categoryBitMask = NodeName.arrow.category()
        arrow.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.enemy.category()|NodeName.obstacle.category()|NodeName.itemBox.category()|NodeName.enemyBall.category()
        arrow.physicsBody!.contactTestBitMask = NodeName.frame_ground.category()|NodeName.enemy.category()|NodeName.obstacle.category()|NodeName.itemBox.category()|NodeName.enemyBall.category()
        
        //矢射撃、引っ張った距離と角度からベクトルを作る
        let    x = sin(self.shootRadian)
        let    y = cos(self.shootRadian)
        let pw = self.drawLength / 150.0
        let vector: CGVector = CGVector(dx: -(self.drawPower*pw*x), dy: self.drawPower*pw*y)
        arrow.physicsBody!.velocity = vector
        
        //プレイヤーキャラのアニメーション
        self.playerNode.attack(attackToRight: true)
        
        //射撃した矢の数を更新
        self.shotArrows += 1
        //所持矢の数を更新
        self.haveArrows -= 1
    }
}
