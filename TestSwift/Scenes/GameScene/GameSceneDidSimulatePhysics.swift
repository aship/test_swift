//
//  GameSceneDidSimulatePhysics.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    //MARK: - すべてのアクションと物理シミュレーション処理後、1フレーム毎に呼び出される
    override func didSimulatePhysics() {
        if self.gameState != .gamePlaying || self.pause {
            if self.gameState == .gameEdit {
                //------------------------------------
                //編集
                //------------------------------------
                //画面スクロール
                if self.screenScrollRight {
                    var x = self.baseNode.position.x - 2
                    
                    if x <= -(self.screenSize.width - screenWidth) {
                        x = -(self.screenSize.width - screenWidth)
                    }
                    
                    self.baseNode.position = CGPoint(x: x,
                                                     y: self.baseNode.position.y)
                } else if self.screenScrollLeft {
                    var x = self.baseNode.position.x + 2
                    
                    if x > 0 {
                        x = 0
                    }
                    
                    self.baseNode.position = CGPoint(x: x,
                                                     y: self.baseNode.position.y)
                }
            }
            
            //ゲームプレイ中でなければ抜ける
            return
        }
        
        //MARK: ゲームクリア
        if self.playerNode.position.x >= self.screenSize.width && self.gameState == .gamePlaying{
            
            self.gameState = .gameWin    //ゲームステータス変更
            return
        }
        
        //MARK: 画面をスクロールさせる
        //移動中 & ボス戦ではない
        if self.moving &&
            self.battleOnBoss == false {
            // 攻撃中 & ダメージ中ではない
            if self.playerNode.isAttacking == false &&
                self.playerNode.isTakingDamage == false {
                //プレイヤーキャラのベクトルを更新
                self.playerNode.physicsBody!.velocity = CGVector(dx: self.playerNode.velocity,
                                                                 dy: 0)
                //シーン上でのプレイヤーの座標をbaseNodeからの位置に変換
                let PlayerPt = self.convert(self.playerNode.position,
                                            from: self.baseNode)
                
                // シーン上でプレイヤー位置を基準にしてbaseNodeの位置を変更する
                var x = self.baseNode.position.x - PlayerPt.x + self.playerInitX
                
                if x <= -(self.screenSize.width - screenWidth) {
                    x = -(self.screenSize.width - screenWidth)
                }
                else {
                    // 中景のスクロール
                    self.baseNode.enumerateChildNodes(withName: NodeName.middleGround.rawValue,
                                                      using: { (node, stop) -> Void in
                                                        let xx = self.baseNode.position.x - x
                                                        
                                                        node.position = CGPoint(x: node.position.x+(xx/2), y: node.position.y)
                                                      })
                }
                
                self.baseNode.position = CGPoint(x: x, y: self.baseNode.position.y)
            }
        }
        
        //MARK: 敵の移動
        self.baseNode.enumerateChildNodes(withName: NodeName.enemy.rawValue,
                                          using: { (node, stop) -> Void in
            if node.position.y < 0 ||
                node.position.x < 0 ||
                node.position.x > self.screenSize.width {
                node.removeFromParent()    //画面外に出た敵を消す
            }
            else{
                let enemy = node as! CharactorNode
                
                if enemy.isTakingDamage || enemy.hp <= 0 {
                    //ダメージアニメーション中なら移動停止
                    enemy.stopTextureAnimation()
                    enemy.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                } else {
                    // 距離を計測
                    let length = self.makeLength(pt1: self.playerNode.position,
                                                    pt2: enemy.position)
                    
                    if length < screenWidth {
                        //プレイヤーキャラと画面内の距離で移動していない
                        if enemy.isMoving == false {
                            enemy.startMoveTextureAnimation()
                        }
                        
                        enemy.physicsBody!.velocity = CGVector(dx: -enemy.velocity, dy: 0)
                        
                        //ボス戦開始
                        if enemy.isBoss &&
                            length <= screenWidth - 48 - (enemy.size.width / 2) &&
                            self.battleOnBoss == false {
                            self.battleOnBoss = true
                        }
                    } else if enemy.isMoving {
                        //プレイヤーキャラと画面外の距離で移動中
                        enemy.physicsBody!.velocity = CGVector(dx: 0,
                                                               dy: 0)
                    }
                }
            }
        })
        
        
        //MARK: 矢
        self.baseNode.enumerateChildNodes(withName: NodeName.arrow.rawValue,
                                          using: { (node, stop) -> Void in
            //矢をベクトル方向に回転させる
            let pt = node.position
            let vector = node.physicsBody?.velocity    //矢のベクトルを取り出す
            //ベクトルを角度（ラジアン）に変換する
            let radian: CGFloat = atan2((pt.y+vector!.dy)-pt.y,
                                        (pt.x+vector!.dx)-pt.x)
            //　角度の差分を計算して更新
            node.zRotation = radian - CGFloat(Double.pi / 2)
        })
    }
}
