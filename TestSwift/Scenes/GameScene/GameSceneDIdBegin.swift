//
//  GameSceneDIdBegin.swift
//  ArrowShooter
//
//  Created by aship on 2020/11/09.
//  Copyright © 2020 STUDIO SHIN. All rights reserved.
//

import SpriteKit

extension GameScene {
    //MARK: 接触判定
    func didBegin(_ contact: SKPhysicsContact) {
        
        if self.gameState != .gamePlaying {
            return    //ゲームプレイ中でなければ抜ける
        }
        
        //オブジェクトの名前
        let bodyNameA: String! = contact.bodyA.node?.name
        let bodyNameB: String! = contact.bodyB.node?.name
        if bodyNameA==nil || bodyNameB==nil {
            return    //どちらかの名前がnilならなにもしない
        }
        
        //２点間の距離を計測
        let lenAtoB = self.makeLength(pt1: self.playerNode.position, pt2: contact.bodyB.node!.position)
        
        var ground_node: SKNode?
        var arrow_node: SKSpriteNode?
        var player_node: CharactorNode?
        var enemy_node: CharactorNode?
        
        //地面ノードを得る
        if NodeName.frame_ground.rawValue==bodyNameA {
            ground_node = contact.bodyA.node
        } else if NodeName.frame_ground.rawValue==bodyNameB {
            ground_node = contact.bodyB.node
        }
        
        //矢ノードを得る
        if NodeName.arrow.rawValue==bodyNameA {
            arrow_node = contact.bodyA.node as? SKSpriteNode
        } else if NodeName.arrow.rawValue==bodyNameB {
            arrow_node = contact.bodyB.node as? SKSpriteNode
        }
        
        //プレイヤーノードを得る
        if NodeName.player.rawValue==bodyNameA {
            player_node = contact.bodyA.node as? CharactorNode
        } else if NodeName.player.rawValue==bodyNameB {
            player_node = contact.bodyB.node as? CharactorNode
        }
        
        //敵ノードを得る
        if NodeName.enemy.rawValue==bodyNameA {
            enemy_node = contact.bodyA.node as? CharactorNode
        } else if NodeName.enemy.rawValue==bodyNameB {
            enemy_node = contact.bodyB.node as? CharactorNode
        }
        
        
        var obstacle_node: SKSpriteNode?
        var box_node: SKSpriteNode?
        var item_node: SKSpriteNode?
       
        //障害物ノードを得る
        if NodeName.obstacle.rawValue==bodyNameA {
            obstacle_node = contact.bodyA.node as? SKSpriteNode
        } else if NodeName.obstacle.rawValue==bodyNameB {
            obstacle_node = contact.bodyB.node as? SKSpriteNode
        }
        
        //ボックスノードを得る
        if NodeName.itemBox.rawValue==bodyNameA {
            box_node = contact.bodyA.node as? SKSpriteNode
        } else if NodeName.itemBox.rawValue==bodyNameB {
            box_node = contact.bodyB.node as? SKSpriteNode
        }
        //アイテムノードを得る
        if NodeName.item.rawValue==bodyNameA {
            item_node = contact.bodyA.node as? SKSpriteNode
        } else if NodeName.item.rawValue==bodyNameB {
            item_node = contact.bodyB.node as? SKSpriteNode
        }
        
        var ball_node: SKSpriteNode?
        //敵の玉ノードを得る
        if NodeName.enemyBall.rawValue==bodyNameA {
            ball_node = contact.bodyA.node as? SKSpriteNode
        } else if NodeName.enemyBall.rawValue==bodyNameB {
            ball_node = contact.bodyB.node as? SKSpriteNode
        }
        
        //------------------
        //MARK: 矢が接触！
        //------------------
        if let arrow = arrow_node {
            //ダメージ値を計算
            //距離が近ければダメージ増加
            var addVal = screenWidth - lenAtoB
            if addVal < 0 {
                addVal = 0
            }
            var damageVal = (self.playerNode.attack + addVal)
            let drawingBow = arrow.userData?["drawingBow"] as? Bool
            if drawingBow != nil && drawingBow == true {
                damageVal *= 1.2
            }
            
            //MARK: -> 地面と接触
            if nil != ground_node {
                //矢をアニメーションで消す
                arrow.name = nil    //接触処理を抜けさせるために名前を無くす
                arrow.physicsBody?.isDynamic = false    //物理シミュレーション無効
                let actions = [ SKAction.fadeAlpha(to: 0, duration: 0.25),
                                SKAction.removeFromParent()]
                arrow.run(SKAction.sequence(actions))
            }
            //MARK: -> 敵と接触
            if let enemy = enemy_node {
                
                self.hitArrows += 1    //ヒットした矢の数を更新
                //矢を消す
                arrow.removeFromParent()
                if enemy.hp > 0 {
                    //ダメージ値を表示する
                    showNumber(CGPoint(    x: enemy.position.x, y: enemy.position.y+enemy.size.height),
                               value: Int(damageVal), fileName: "num", speed: 1.0)
                    //ダメージ！
                    enemy.hp -= damageVal
                    if enemy.hp <= 0 {
                        //SE再生
                        self.run(SKAction.playSoundFileNamed("se_break.m4a", waitForCompletion: false))
                        
                        /*+++++++++++++++++++
                         死亡
                         +++++++++++++++++++*/
                        //経験値を計算
                        //距離が遠いほど経験を加算
                        let exp = enemy.exp + Int(lenAtoB / 2)
                        //経験値を表示する
                        showNumber(CGPoint(x: enemy.position.x, y: enemy.position.y),
                                   value: exp, fileName: "num_yel", speed: 1.2)
                        self.takeExp += exp            //経験値更新
                        //敵をアニメーションで消す
                        let actions = [    SKAction.rotate(byAngle: -CGFloat(Double.pi )/2, duration: 0.2),
                                           SKAction.moveBy(x: 10, y: -20, duration: 0.2),
                                           SKAction.fadeAlpha(to: 0, duration: 0.2)]
                        enemy.run(SKAction.sequence([    SKAction.group(actions),
                                                         SKAction.removeFromParent()]))
                        //ボスを倒した
                        if enemy.isBoss {
                            //カウントダウンを停止
                            self.removeAction(forKey: "timeCountAction")
                            //ボス戦フラグをOFF
                            self.battleOnBoss = false
                        }
                        
                    } else {
                        //SE再生
                        self.run(SKAction.playSoundFileNamed("se_hit1.m4a", waitForCompletion: false))
                        
                        /*+++++++++++++++++++
                         生存
                         +++++++++++++++++++*/
                        //ダメージアニメーション
                        enemy.damage(damageFromLeft: true)
                    }
                }
            }
            //MARK: -> 障害物と接触
            if let obstacle = obstacle_node {
                
                self.hitArrows += 1    //ヒットした矢の数を更新
                //矢を消す
                arrow.removeFromParent()
                
                //ダメージ値を表示する
                showNumber(CGPoint(x: obstacle.position.x, y: obstacle.position.y+obstacle.size.height),
                           value: Int(damageVal), fileName: "num", speed: 1.0)
                //耐久力を減らす
                var durability = obstacle.userData?["durability"] as! Float
                durability -= Float(damageVal)
                if durability <= 0 {
                    //破壊
                    breakObstacle(obstacle)
                }
                else {
                    //SE再生
                    self.run(SKAction.playSoundFileNamed("se_hit1.m4a", waitForCompletion: false))
                    
                    //残存
                    //耐久力を更新
                    obstacle.userData?["durability"] = durability
                    //アニメーション
                    let group1 = [    SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                                      SKAction.rotate(toAngle: -CGFloat(Double.pi / 8), duration: 0.05)]
                    let group2 = [    SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                                      SKAction.rotate(toAngle: 0, duration: 0.05)]
                    let actions = [    SKAction.group(group1),
                                       SKAction.group(group2)]
                    obstacle.run(SKAction.sequence(actions))
                }
            }
            
            //MARK: -> アイテムボックスと接触
            if let box = box_node {
                
                self.hitArrows += 1    //ヒットした矢の数を更新
                let pt = box.position
                let itemNum = box.userData?["number"] as! Int
                //矢を消す
                arrow.removeFromParent()
                //アイテムボックスを消す
                box.removeFromParent()
                
                if itemNum >= 4 && itemNum <= 6 {
                    //敵キャラが出現！
                    let enemy = self.makeEnemy(itemNum-4, position: pt)
                    //上に飛び跳ねて出現
                    let actions = [    SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 0.1),
                                       SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.05)]
                    enemy?.run(SKAction.sequence(actions))
                }
                else {
                    //アイテム作成
                    let item = self.makeItem(itemNum, position: pt)
                    if item != nil {
                        //SE再生
                        self.run(SKAction.playSoundFileNamed("se_button.m4a", waitForCompletion: false))
                        //出現と消滅アニメーション
                        //間隔の長い点滅
                        let flash1 = [    SKAction.fadeAlpha(to: 1.0, duration: 0.2),
                                          SKAction.fadeAlpha(to: 0.0, duration: 0.2)]
                        let flashAction1 = SKAction.repeat(SKAction.sequence(flash1), count: 5)
                        //間隔の短い点滅
                        let flash2 = [    SKAction.fadeAlpha(to: 1.0, duration: 0.1),
                                          SKAction.fadeAlpha(to: 0.0, duration: 0.1)]
                        let flashAction2 = SKAction.repeat(SKAction.sequence(flash2), count: 5)
                        //上に飛び跳ねて３秒待機後、点滅して消える
                        let actions = [    SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 0.1),
                                           SKAction.wait(forDuration: 3.0),
                                           flashAction1,
                                           flashAction2,
                                           SKAction.removeFromParent()]
                        item?.run(SKAction.sequence(actions))
                    }
                    else{
                        //パーティクル（スモーク）
                        let particle = self.loadParticle("Smoke")
                        particle?.numParticlesToEmit = 2                    //パーティクルの放出限界数
                        self.baseNode.addChild(particle!)
                        particle?.zPosition = 100
                        particle?.position = box.position
                    }
                }
            }
            //MARK: -> 敵の玉と接触
            if let ball = ball_node {
                //SE再生
                self.run(SKAction.playSoundFileNamed("se_break.m4a", waitForCompletion: false))
                
                //パーティクル（スパーク）
                let particleSpark = self.loadParticle("Spark")
                
                
                if let unwrapped = particleSpark {
                    // パーティクルの放出限界数
                    unwrapped.numParticlesToEmit = 100
                    
                    unwrapped.zPosition = 100
                    unwrapped.position = ball.position
                    self.baseNode.addChild(unwrapped)
                }
                
                
                
                
                //玉を消す
                ball.removeFromParent()
                //矢を消す
                arrow.removeFromParent()
            }
            
            //矢のヒット率通知
            var avr: Float
            if self.hitArrows == 0 {
                avr = 0
            }else{
                avr = Float(self.hitArrows) / Float(self.shotArrows)
            }
            self.gameDelegate?.gameSceneNotificationArrowHitAvr(avr)
            
        }
        //------------------
        //MARK: プレイヤーが接触！
        //------------------
        else if nil != player_node {
            //MARK: -> 敵と接触
            if nil != enemy_node {
                //ゲームオーバー！！
                self.gameState = .gameLose    //ゲームステータス変更
            }
            //MARK: -> アイテムと接触
            if let item = item_node {
                //SE再生
                self.playerNode.run(SKAction.playSoundFileNamed("se_button.m4a", waitForCompletion: false))
                
                //コイン
                let money = item.userData!["money"] as! Int
                //コインの額を表示する
                showNumber(CGPoint(x: self.playerNode.position.x,
                                   y: self.playerNode.position.y + self.playerNode.size.height),
                           value: money,
                           fileName: "num_yel",
                           speed: 1.0)
                self.takeMoney += money
                //アイテムを消す
                item.removeFromParent()
            }
            //MARK: -> 敵の玉と接触
            if let ball = ball_node {
                //敵の玉を消す
                ball.removeFromParent()
                //ゲームオーバー！！
                self.gameState = .gameLose    //ゲームステータス変更
            }
        }
        //------------------
        //MARK: 敵が接触！
        //------------------
        else if let enemy = enemy_node {
            //MARK: -> 障害物と接触
            if let obstacle = obstacle_node {
                
                //ヒットマーク表示
                let hitMark = SKSpriteNode(imageNamed: "mark_hit")
                self.baseNode.addChild(hitMark)
                hitMark.zPosition = 100
                hitMark.position = self.convert(contact.contactPoint, to: self.baseNode)
                let actions = [
                    SKAction.scale(to: 1.5, duration: 0.2),
                    SKAction.removeFromParent()
                ]
                hitMark.run(SKAction.sequence(actions))
                
                //耐久力を減らす
                var durability = obstacle.userData?["durability"] as! CGFloat
                durability -= enemy.attack
                if durability <= 0 {
                    //破壊
                    breakObstacle(obstacle)
                }
                else {
                    //残存
                    //耐久力を更新
                    obstacle.userData?["durability"] = durability
                    //敵を少し後退させる
                    enemy.run(SKAction.moveBy(x: 20, y: 0, duration: 0.1))
                }
            }
        }
    }
    
    //-----------------------------------------
    //ネスト関数
    //-----------------------------------------
    //数字表示
    func showNumber(_ position: CGPoint, value: Int, fileName: String, speed: Double) {
        
        let damageNode = self.makeNumberSpriteNode(value, numName: fileName)
        
        self.baseNode.addChild(damageNode)
        damageNode.position = position
        damageNode.zPosition = 100
        damageNode.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: 60, duration: 0.1 * speed),
            SKAction.moveBy(x: 0, y: -70, duration: 0.05 * speed),
            SKAction.moveBy(x: 0, y: 10, duration: 0.05 * speed),
            SKAction.wait(forDuration: 0.2),
            SKAction.removeFromParent()
        ]))
    }
    
    //障害物を破壊
    func breakObstacle(_ obstacle: SKSpriteNode){
        
        //パーティクル（スモーク）
        let particle = self.loadParticle("Smoke")
       
        
        if let unwrapped = particle {
            unwrapped.numParticlesToEmit = 6                    //パーティクルの放出限界数
            unwrapped.particleColor = UIColor.white    //カラー
            unwrapped.particleColorBlendFactor = 0.0            //色のブレンド
            
            self.baseNode.addChild(unwrapped)
            
            
            unwrapped.zPosition = 100
            unwrapped.position = obstacle.position
        }
        
        
        
        
        
        
        //SE再生
        self.run(SKAction.playSoundFileNamed("se_break.m4a", waitForCompletion: false))
        
        var name_l: String!
        var name_r: String!
        let itemNum = obstacle.userData?["number"] as! Int
        switch itemNum {
        case 0:        //岩
            name_l = "rock_l"
            name_r = "rock_r"
        default:
            name_l = nil
            name_r = nil
        }
        if name_l != nil && name_r != nil {
            //左に割れる岩
            let obstacle_l = SKSpriteNode(imageNamed: name_l)
            self.baseNode.addChild(obstacle_l)
            obstacle_l.position = obstacle.position
            obstacle_l.zPosition = obstacle.zPosition
            let groupeAry_l = [    SKAction.fadeAlpha(to: 0, duration: 0.25),
                                   SKAction.moveBy(x: -30, y: 30, duration: 0.25),
                                   SKAction.rotate(byAngle: CGFloat(Double.pi) / 2,
                                                   duration: 0.25)]
            let seqAry_l = [SKAction.group(groupeAry_l),
                            SKAction.removeFromParent()]
            obstacle_l.run(SKAction.sequence(seqAry_l))
            //右に割れる岩
            let obstacle_r = SKSpriteNode(imageNamed: name_r)
            self.baseNode.addChild(obstacle_r)
            obstacle_r.position = obstacle.position
            obstacle_r.zPosition = obstacle.zPosition
            let groupeAry_r = [    SKAction.fadeAlpha(to: 0, duration: 0.25),
                                   SKAction.moveBy(x: 30, y: 30, duration: 0.25),
                                   SKAction.rotate(byAngle: -(CGFloat(Double.pi) / 2),
                                                   duration: 0.25)]
            let seqAry_r = [SKAction.group(groupeAry_r),
                            SKAction.removeFromParent()]
            obstacle_r.run(SKAction.sequence(seqAry_r))
        }
        //障害物破壊を消す
        obstacle.removeFromParent()
    }
    
    func loadParticle(_ name: String) -> SKEmitterNode! {
   //     let path = Bundle.main.path(forResource: name, ofType: "sks")!
        
     //   let fire = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! SKEmitterNode?

        do {
            let fileURL = Bundle.main.url(forResource: name, withExtension: "sks")!
            let fileData = try Data(contentsOf: fileURL)
            let fire = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as! SKEmitterNode
            
            return fire
        } catch {
            print("didn't work")
            
            return SKEmitterNode()
        }
        
        
        
    }
}
