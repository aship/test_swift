//
//  CharactorNode.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

enum CharaDirection: Int {
    case kCharaDirectionDown = 0     // 下移動
    case kCharaDirectionLeft = 1       // 左移動
    case kCharaDirectionUp = 2          // 上移動
    case kCharaDirectionRight = 3       // 右移動
}

class CharactorNode: SKSpriteNode {
    // 向いている角度（ラジアン）
    var angle: CGFloat = 0.0
    var velocity: CGFloat = 0.0
    
    // アニメーション１コマのスピード
    var animeSpeed: CGFloat = 0.0
    
    // キャラクターHP
    var hp: CGFloat = 0.0
    
    // 移動方向
    var charaDirection: CharaDirection = .kCharaDirectionDown
    
    // テクスチャアニメ中フラグ
    var inTextureAnime: Bool = false
    
    // 攻撃中フラグ
    var inShootAnime: Bool = false
    
    // ダメージ中フラグ
    var isGetDamage: Bool = false
    
    // テクスチャアトラス
    var textureAtlas = SKTextureAtlas()
    
    class func charactorNodeWith(_ name: String,
                                 TextureAtlas textureAtlas: SKTextureAtlas) -> CharactorNode {
        //プレイヤーノード
        let texname: String = "\(name)_down1"
        let texture: SKTexture = textureAtlas.textureNamed(texname)
        let charaNode: CharactorNode = CharactorNode(texture: texture)
        
        charaNode.textureAtlas = textureAtlas
        charaNode.name = name
        charaNode.physicsBody = SKPhysicsBody(circleOfRadius: charaNode.size.width/2)
        charaNode.physicsBody!.affectedByGravity = false
        //重力適用なし
        charaNode.physicsBody?.allowsRotation = false
        //衝突による角度変更なし
        charaNode.physicsBody!.linearDamping = 1.0
        //空気抵抗
        charaNode.setAngle(CGFloat(Double.pi), Velocity: 0)
        charaNode.animeSpeed = 0.1
        return charaNode
    }
    
    class func angleToDirection(_ direction: CGFloat) -> CharaDirection {
        var  res: CharaDirection?
        
        //計算しやすいようにラジアンから弧度法に直す
        let r: CGFloat = direction * 180 / CGFloat(Double.pi)
        
        if r >= -135 && -45 > r {
            res = .kCharaDirectionRight
            //右
        } else if r >= -45 && 45 > r {
            res = .kCharaDirectionUp
            //上
        } else if r >= 45 && 135 > r {
            res = .kCharaDirectionLeft
            //左
        } else {
            res = .kCharaDirectionDown
            //下
        }
        
        return res!
    }
    
    
    func stop() {
        if self.inShootAnime {
            return
        }
        
        self.velocity = 0
        
        var direction: String
        
        if self.charaDirection == .kCharaDirectionRight {
            direction = "right"
            //右
        } else if self.charaDirection == .kCharaDirectionUp {
            direction = "up"
            //上
        } else if self.charaDirection == .kCharaDirectionLeft {
            direction = "left"
            //左
        } else {
            direction = "down"
            //下
            
        }
        
        //停止
        self.inTextureAnime = false
        self.removeAction(forKey: "charaMove")
        
        let texname: String = "\(self.name ?? "")_\(direction)1"
        let texture: SKTexture = self.textureAtlas.textureNamed(texname)
        
        self.texture = texture
    }
    
    func update() {
        if self.inShootAnime {
            return
        }
        //角度からベクトルを求める
        let x: CGFloat = sin(self.angle) * self.velocity
        let y: CGFloat = cos(self.angle) * self.velocity
        //ベクトルを加える
        self.physicsBody!.velocity = CGVector(dx: -x,
                                              dy: y)
    }
    
    
    func shoot(response: @escaping (_ angle: CGFloat) -> Void) {
        if self.inShootAnime {
            return
        }
        
        self.stop()
        self.inShootAnime = true
        
        var retAngle: CGFloat = 0
        
        var direction: String
        
        if self.charaDirection == .kCharaDirectionRight {
            direction = "right"
            //右
            retAngle = CGFloat(-(Double.pi/2))
        } else if self.charaDirection == .kCharaDirectionUp {
            direction = "up"
            //上
            retAngle = 0
        } else if self.charaDirection == .kCharaDirectionLeft {
            direction = "left"
            //左
            retAngle = CGFloat(Double.pi/2)
        } else {
            direction = "down"
            //下
            retAngle = CGFloat(Double.pi)
            
        }
        
        let ary: [SKTexture] = [self.textureAtlas.textureNamed("\(self.name!)_\(direction)1"),
                                self.textureAtlas.textureNamed("\(self.name!)_\(direction)4"),
                                self.textureAtlas.textureNamed("\(self.name!)_\(direction)5")]
        
        let action: SKAction = SKAction.animate(with: ary,
                                                timePerFrame: 0.1,
                                                resize: true,
                                                restore: true)
        
        self.run(action,
                 completion: {
                    self.inShootAnime = false
                    
                    
                    // これ何に使われてる？
                    print(retAngle)
                    response(retAngle)
                    
                 })
    }
    
    func setHp(_ hp: CGFloat) {
        self.hp = hp
        
        if self.hp < 0 {
            self.hp = 0
        }
    }
    
    //ダメージフラグ
    func getDamage() {

        var direction: String
        
        if self.charaDirection == .kCharaDirectionRight {
            direction = "right"
            //右
        } else if self.charaDirection == .kCharaDirectionUp {
            direction = "up"
            //上
        } else if self.charaDirection == .kCharaDirectionLeft {
            direction = "left"
            //左
        } else {
            direction = "down"
            //下
            
        }
        
        if self.isGetDamage {
            self.velocity = 0
            
            self.inTextureAnime = false
            
            self.removeAction(forKey: "charaMove")
            
            self.texture = self.textureAtlas.textureNamed("\(self.name!)_\(direction)6")
            
            self.run(SKAction.wait(forDuration: 0.5),
                     completion: {
                self.isGetDamage = false
                //一定時間でOFFにする
                
            })
        } else {
            self.texture = self.textureAtlas.textureNamed("\(self.name!)_\(direction)1")
            
        }
    }
}
