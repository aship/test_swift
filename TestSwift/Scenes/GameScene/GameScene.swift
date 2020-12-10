//
//  GameScene.swift
//  ArrowShooter
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var touchPoint = CGPoint(x: 0,
                             y: 0)
    
    var gameDelegate: Int = 0 // id?
    
    var baseNode = SKNode()
    var playerNode = CharactorNode()
    
    var mapSize = CGSize(width: 0,
                         height: 0)
    
    
    let kPlayerName = "ninja"
    let kEnemyName = "zombi"
    let kWeponName = "wepon"
    
    let frameCategory =  0x1 << 0    //外枠
    let playerCategory =  0x1 << 1    //プレイヤー
    let enemyCategory =  0x1 << 2    //敵
    let weponCategory =  0x1 << 3    //手裏剣
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        self.addChild(self.baseNode)
        //マップの全体サイズ
        self.mapSize = CGSize(width: 320 * 3,
                              height: 320 * 3)
        //マップ表示
        let texture: SKTexture = SKTexture(imageNamed: "back")
        
        for y in 0..<3 {
            for x in 0..<3 {
                //背景ノード
                var node: SKSpriteNode
                node = SKSpriteNode(texture: texture)
                node.position = CGPoint(x: (node.size.width / 2) + CGFloat(x * 320),
                                        y: (node.size.height / 2) + CGFloat(y * 320))
                self.baseNode.addChild(node)
            }
        }
        
        // プレイヤーノード
        let playerAtlas: SKTextureAtlas = SKTextureAtlas(named: "ninja")
        self.playerNode = CharactorNode.charactorNodeWith(kPlayerName,
                                                          TextureAtlas: playerAtlas)
        self.playerNode.hp = 100
        self.baseNode.addChild(self.playerNode)
        self.playerNode.position = CGPoint(x: 480,
                                           y: 480)
        self.playerNode.physicsBody!.categoryBitMask = UInt32(playerCategory)
        self.playerNode.physicsBody!.collisionBitMask = UInt32(enemyCategory|frameCategory)
        //マップの外枠フレーム当たり
        let frameNode: SKNode = SKNode()
        self.baseNode.addChild(frameNode)
        
        frameNode.position = CGPoint(x: (self.mapSize.width/2),
                                     y:    (self.mapSize.height/2))
        
        frameNode.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(self.mapSize.width / 2),
                                                                   y: -(self.mapSize.height / 2),
                                                                   width: self.mapSize.width,
                                                                   height: self.mapSize.height))
        
        
        
        frameNode.physicsBody!.categoryBitMask = UInt32(frameCategory)
        frameNode.physicsBody!.collisionBitMask = UInt32(playerCategory)
        //接触デリゲート
        self.physicsWorld.contactDelegate = self
        // 敵ノード
        let enemyPos: [CGPoint] = [CGPoint(x: 500, y: 700),
                                   CGPoint(x: 620, y: 710),
                                   CGPoint(x: 540, y: 740),
                                   CGPoint(x: 620, y: 670),
                                   CGPoint(x: 440, y: 760),
                                   CGPoint(x: 440, y: 370),
                                   CGPoint(x: 300, y: 230),
                                   CGPoint(x: 400, y: 240),
                                   CGPoint(x: 820, y: 670),
                                   CGPoint(x: 330, y: 560)]
        
        
        let enemyAtlas = SKTextureAtlas(named: "zombi")
        
        for i in 0 ..< 10 {
            let enemy = CharactorNode.charactorNodeWith(kEnemyName,
                                                        TextureAtlas: enemyAtlas)
            
            self.baseNode.addChild(enemy)
            
            enemy.hp = 30
            enemy.position = enemyPos[i]
            enemy.physicsBody!.categoryBitMask = UInt32(enemyCategory)
            enemy.physicsBody!.collisionBitMask = UInt32(playerCategory | enemyCategory | frameCategory)
            enemy.physicsBody!.contactTestBitMask = UInt32(playerCategory)
        }
    }
    
    override func didSimulatePhysics() {
        self.playerNode.update()
        //プレイヤーの位置に合わせてオートスクロール
        //      var pt: CGPoint = self.convertPoint(self.playerNode.position,
        //                                        fromNode: self.baseNode)
        
        //  var pt: CGPoint = self.convertPoint(self.playerNode.position,
        //                                fromNode: self.baseNode)
        
        let pt = self.baseNode.convert(self.playerNode.position,
                                       to: self)
        
        //    self.convertPo
        
        
        //シーン上でベースノードの位置を変更する
        var mv_x: CGFloat
        var mv_y: CGFloat
        mv_x = self.baseNode.position.x - pt.x
        mv_y = self.baseNode.position.y - pt.y
        self.baseNode.position = CGPoint(x: mv_x,
                                         y: mv_y)
        //手裏剣
        self.baseNode.enumerateChildNodes(withName: kWeponName) { node, stop in
            let pt: CGPoint = node.position
            
            if pt.x < 0 ||
                pt.y < 0 ||
                pt.x > self.mapSize.width ||
                pt.y > self.mapSize.height {
                //マップ外に出た手裏剣を削除
                node.removeFromParent()
            }
        }
        
        
        //   func postLoginApi(email: String, password: String, completion: @escaping (_ success: Bool, _ apiToken: ApiToken, _ alertMessage: String) -> Void) {
        
        
        //     postLoginApi(email: self.email, password: self.password) { success, apiToken,  alertMessage in
        
        //敵AI
        self.baseNode.enumerateChildNodes(withName: kEnemyName) { node, stop in
            let enemy = node as! CharactorNode
            
            if enemy.isGetDamage == false {
                let dogPos: CGPoint = self.playerNode.position
                let enemyPos: CGPoint = enemy.position
                
                // 距離判定
                let x: Double = Double(abs(enemyPos.x - dogPos.x))
                let y: Double = Double(abs(enemyPos.y - dogPos.y))
                
                let length: CGFloat = CGFloat(sqrt((x * x) + (y * y)) * 2)
                
                if length < 700 {
                    //プレイヤーの方向に移動する
                    let angle: CGFloat = CGFloat(-(atan2f(Float(dogPos.x - enemyPos.x),
                                                          Float(dogPos.y - enemyPos.y))))
                    
                    if enemy.velocity == 0 {
                        enemy.velocity = 30
                        enemy.setAngle(angle, Velocity: enemy.velocity)
                    } else {
                        let direction = CharactorNode.angleToDirection(angle)
                        
                        enemy.charaDirection = direction
                        enemy.setCharaDirection(direction)
                        
                        enemy.angle = angle
                        
                    }
                } else if enemy.velocity != 0 {
                    enemy.stop()
                }
                enemy.update()
            }
        }
    }
}

