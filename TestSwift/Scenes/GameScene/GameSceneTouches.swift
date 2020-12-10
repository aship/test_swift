//
//  GameSceneTouches.swift
//  ArrowShooter
//
//  Created by aship on 2020/11/09.
//  Copyright © 2020 STUDIO SHIN. All rights reserved.
//

import SpriteKit

extension GameScene {
    //タッチダウンされた時に呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.gameState != .gamePlaying || self.pause {
            //------------------------------------
            //編集
            //------------------------------------
            if self.gameState == .gameEdit {
                self.putNode = nil
                //タップした位置のノードを得る
                for touch in touches {
                    let location = touch.location(in: self.baseNode)
                    let chaNode = self.baseNode.atPoint(location) as? CharactorNode
                    if chaNode != nil {
                        self.putNode = chaNode
                    } else {
                        let itemNode = self.baseNode.atPoint(location) as? SKSpriteNode
                        if itemNode != nil && itemNode!.userData != nil {
                            self.putNode = itemNode
                        }
                    }
                    //新規作成
                    if self.putNode == nil && self.editMode == 0 {
                        let pt = CGPoint(x: position.x, y: position.y+22)
                        switch self.putKind {
                        case 0:        //敵
                            self.putNode = self.makeEnemy(self.putNumber, position: pt)
                        case 1:        //障害物
                            self.putNode = self.makeObstacle(self.putNumber, position: pt)
                        case 2:        //アイテム in ボックス
                            self.putNode = self.makeItemBox(self.putNumber, position: pt)
                        default:
                            self.putNode = nil
                        }
                    }
                }
            }
            return    //ゲームプレイ中でなければ抜ける
        }
        
        for touch in touches {
            //ゲームコントローラノードを検索
            let pt = touch.location(in: self)
            let touchNode: SKNode? = self.atPoint(pt)
            
            if let node = touchNode {
                //------------------------------------
                //弓をタップ
                //------------------------------------
                if    node === self.cntBackNode ||
                        node === self.cntBowNode ||
                        node === self.cntRotNode ||
                        node === self.cntArrowNode {
                    
                    //プレイヤー移動停止
                    self.moveTimer?.invalidate()    //タイマー停止
                    self.moving = false
                    self.playerNode.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                    
                    //待機アニメーション開始
                    self.playerNode.startWaitTextureAnimation()

                    let location = touch.location(in: self.cntBackNode)
                    self.drawingBow = false
                    
                    if self.shootOK {
                        self.deformShootControl(location)        //コントローラを変形させる
                    }
                    else {
                        let centerPt = self.cntRotNode.position
                        //中心とタップ位置の角度により回転コントローラノードを回転させる
                        let radian = atan2(location.y-centerPt.y,
                                           location.x-centerPt.x)
                        self.shootRadian = radian - CGFloat(Double.pi * 1.5)
                        self.cntRotNode.zRotation = self.shootRadian
                    }
                }
            }
        }
    }
    
    //射撃コントローラを変形させる
    func deformShootControl(_ location: CGPoint) {
        let centerPt = self.cntRotNode.position
        //中心とタップ位置の角度により回転コントローラノードを回転させる
        let radian = atan2(location.y-centerPt.y,
                           location.x-centerPt.x)
        
        self.shootRadian = radian - CGFloat(Double.pi * 1.5)
        self.cntRotNode.zRotation = self.shootRadian
        
        // 中心とタップ位置の距離により弓を変形させる
        // 距離を計測
        let length = self.makeLength(pt1: centerPt, pt2: location)
        self.drawLength = length
        var perx = 1 - (self.drawLength / 200)
        
        if perx < 0.5 {
            perx = 0.5
        }
        
        let pery = (self.drawLength / 200) + 1
        self.cntBowNode.xScale = perx
        self.cntBowNode.yScale = pery
        //中心とタップ位置の距離により矢の位置をずらす
        self.cntArrowNode.position = CGPoint(x: 0, y: -(self.drawLength*0.5))
        
    }
    
    //タッチムーブされた時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.gameState != .gamePlaying || self.pause {
            //------------------------------------
            //編集
            //------------------------------------
            if self.gameState == .gameEdit {
                
                if self.putNode != nil {
                    for touch in touches {
                        let location = touch.location(in: self.baseNode)
                        let pt = CGPoint(x: location.x, y: location.y+22)
                        self.putNode.position = pt
                    }
                }
            }
            return    //ゲームプレイ中でなければ抜ける
        }
        
        
        if self.shootOK {
            if self.drawingBow == false {
                self.drawingBow = true
            }
            for touch in touches {
                let location = touch.location(in: self.cntBackNode)
                self.deformShootControl(location)    //射撃コントローラを変形させる
            }
        }
    }
    //タッチアップされた時に呼ばれる
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.gameState != .gamePlaying || self.pause {
            //------------------------------------
            //MARK: 編集
            //------------------------------------
            if self.gameState == .gameEdit {
                
                if self.putNode != nil && self.editMode == 1 {
                    self.putNode.removeFromParent()    //ノードを削除
                }
                self.putNode = nil
            }
            return    //ゲームプレイ中でなければ抜ける
        }
        
        //------------------------------------
        //MARK:弓をタップ
        //------------------------------------
        if self.shootOK {
            self.shootAnimation()    //コントローラ射撃アニメーション
            
            //プレイヤー位置から矢を射撃する
            let pt = self.playerNode.position
            self.shootArrow(CGPoint(x: pt.x,
                                    y: pt.y+(self.playerNode.size.height/2)))
            //弓を引いているフラグOFF
            self.drawingBow = false
        }
        
        //プレイヤー移動開始タイマー
        self.moveTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(GameScene.moveStartTimer),
            userInfo: nil,
            repeats: false)
    }
}
