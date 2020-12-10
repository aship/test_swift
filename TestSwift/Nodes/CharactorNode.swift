//
//  CharactorNode.swift
//  ArrowShooter
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import SpriteKit


class CharactorNode: SKSpriteNode {
    
    /*===========================================
     プロパティ
     ===========================================*/
    var	chaNumber: Int = 0				//キャラ番号
    var	textureAtlas: SKTextureAtlas!	//テクスチャアトラス
    var	velocity: CGFloat = 0			//移動速度
    var	hp: CGFloat = 0					//キャラクターHP
    var	attack: CGFloat = 0				//攻撃力
    var	reloadDelay: Double = 0			//再装填遅延時間
    var	exp: Int = 0					//経験値
    var isAttacking = false				//攻撃中フラグ
    var isTakingDamage = false			//ダメージ中フラグ
    var isMoving: Bool = false			//移動中フラグ
    var isBoss: Bool = false			//ボスキャラフラグ
    
    
    
    /*===========================================
     イニシャライザ
     ===========================================*/
    init(atlas: SKTextureAtlas!) {
        let texture = atlas.textureNamed("wait1")
        let size = texture.size()
        super.init(texture: texture, color: SKColor.clear, size: size)
        self.textureAtlas = atlas
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*===========================================
     関数
     ===========================================*/
    //待機アニメーション開始
    func startWaitTextureAnimation() {
        let ary = [	self.textureAtlas.textureNamed("wait1"),
                       self.textureAtlas.textureNamed("wait2")]
        let action = SKAction.animate(with: ary,
                                      timePerFrame: 0.2,
                                      resize: true,
                                      restore: true)
        self.run(SKAction.repeatForever(action), withKey: "textureAnimation")
    }
    
    //移動アニメーション開始
    func startMoveTextureAnimation() {
        self.isMoving = true
        let ary = [	self.textureAtlas.textureNamed("move1"),
                       self.textureAtlas.textureNamed("move2"),
                       self.textureAtlas.textureNamed("move1"),
                       self.textureAtlas.textureNamed("move3")]
        let action = SKAction.animate(with: ary,
                                      timePerFrame: 0.1,
                                      resize: true,
                                      restore: true)
        self.run(SKAction.repeatForever(action), withKey: "textureAnimation")
    }
    
    //テクスチャアニメーション停止
    func stopTextureAnimation() {
        self.isMoving = false
        self.removeAction(forKey: "textureAnimation")
        let texture = self.textureAtlas.textureNamed("wait1")
        self.texture = texture
    }
    
    //攻撃アニメーション
    func attack(attackToRight: Bool) {
        self.isAttacking = true
        var actions: [SKAction]
        //右方向に攻撃
        if attackToRight {
            //右方向に移動して戻る
            actions = [	SKAction.moveBy(x: 10, y: 0, duration: 0.025),
                           SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                           SKAction.run({ () -> Void in
                            self.isAttacking = false
                           })]
        }
        //左方向に攻撃
        else{
            //左方向に移動して戻る
            actions = [	SKAction.moveBy(x: -10, y: 0, duration: 0.025),
                           SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                           SKAction.run({ () -> Void in
                            self.isAttacking = false
                           })]
        }
        //アニメーションの連続再生
        self.run(SKAction.sequence(actions), withKey: "attack")
    }
    //ダメージアニメーション
    func damage(damageFromLeft: Bool) {
        self.isTakingDamage = true
        var actions: [SKAction]
        //左から攻撃を受けた
        if damageFromLeft {
            //0.05秒で右に移動して時計まわりに45度回転
            let group1 = [	SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                              SKAction.rotate(toAngle: -CGFloat(Double.pi / 4), duration: 0.05)]
            //0.1秒で元に戻す
            let group2 = [	SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                              SKAction.rotate(toAngle: 0, duration: 0.05),
                              SKAction.run({ () -> Void in
                                self.isTakingDamage = false
                              })]
            //アニメーションの連続再生
            actions = [	SKAction.group(group1),
                           SKAction.group(group2)]
        }
        //右から攻撃を受けた
        else{
            //0.05秒で左に移動して時計まわりに45度回転
            let group1 = [SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                          SKAction.rotate(toAngle: CGFloat(Double.pi / 4), duration: 0.05)]
            //0.1秒で元に戻す
            let group2 = [	SKAction.moveBy(x: 10, y: 0, duration: 0.05),
                              SKAction.rotate(toAngle: 0, duration: 0.05),
                              SKAction.run({ () -> Void in
                                self.isTakingDamage = false
                              })]
            actions = [	SKAction.group(group1),
                           SKAction.group(group2)]
        }
        //アニメーションの連続再生
        self.run(SKAction.sequence(actions))
    }
    
    
    
    //玉発射
    func shootEnemyBall(_ interval: Double) {
        
        //玉発射のアクション
        let ary = [
            SKAction.wait(forDuration: interval, withRange: 1.0),
            SKAction.run({ () -> Void in
                if self.hp > 0 && self.isMoving && self.isTakingDamage==false {
                    //SE再生
                    self.run(SKAction.playSoundFileNamed("se_shot1.m4a", waitForCompletion: false))
                    //玉の作成
                    let name: String = "enemy_ball"
                    let ball = SKSpriteNode(imageNamed: name)		//玉のスプライトを作成
                    self.parent?.addChild(ball)						//親ノードに配置する
                    ball.name = NodeName.enemyBall.rawValue			//列挙型で名前を設定する
                    ball.position = self.position
                    ball.zPosition = NodeName.enemyBall.zPosition()
                    //物理設定
                    let size = ball.size
                    //玉の横幅を直径とする円形の物理体を作成する
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2, center: CGPoint(x: 0, y: 0))
                    //当たり用の設定
                    ball.physicsBody!.categoryBitMask = NodeName.enemyBall.category()
                    ball.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.player.category()
                    ball.physicsBody!.contactTestBitMask = NodeName.frame_ground.category()|NodeName.player.category()
                    
                    //ベクトルを作る
                    let vector: CGVector = CGVector(dx: -70, dy: 600)
                    ball.physicsBody!.velocity = vector
                }
            })]
        let shootBall = SKAction.sequence(ary)
        self.run(SKAction.repeatForever(shootBall), withKey: "shootBall")
    }
}
