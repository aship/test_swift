//
//  GameSceneMissile.swift
//  TestSwift
//
//  Created by aship on 2020/11/12.
//

import SpriteKit

// これ使われてないぽい。。。

extension GameScene {
    //ミサイル発射
    func missaileShooting(_ radian: CGFloat) {
        //名前から宇宙船を検索
        let spaceship: SKNode = self.childNode(withName: kSpaceshipName)!
        //宇宙船の位置
        let spaceship_pt: CGPoint = spaceship.position
        //回転角度から回転速度を求める
        let diff: CGFloat = CGFloat(fabsf(Float(spaceship.zRotation-radian)));
        
        let time: TimeInterval = TimeInterval(diff*0.3)
        //宇宙船回頭
        _isRotating = true
        //回転中フラグON
        let rotate: SKAction = SKAction.rotate(toAngle: radian, duration: time)
        
        spaceship.run(rotate) { [self] in
            // 宇宙船回頭後、ミサイル発射
            self._isRotating = false
            //回転中フラグOFF
            //ミサイル作成
            let missaile: SKSpriteNode = SKSpriteNode(texture: self._textureMissile)
            missaile.position = CGPoint(x: spaceship_pt.x,
                                        y: spaceship_pt.y)
            missaile.name = self.kMissileName
            self.addChild(missaile)
            missaile.physicsBody = SKPhysicsBody(rectangleOf: missaile.size)
            //宇宙船の向きにミサイル発射
            missaile.zRotation = radian
            let x: CGFloat = sin(radian)
            let y: CGFloat = cos(radian)
            missaile.physicsBody!.velocity = CGVector(dx: -(400 * x),
                                                      dy: (400 * y))
            //ベクトル
            //接触設定
            missaile.physicsBody!.categoryBitMask = UInt32(self.missileCategory)
            //カテゴリー（ミサイル）
            missaile.physicsBody!.contactTestBitMask = UInt32(self.meteorCategory)
            //ヒットテストするオブジェクト（隕石）
            missaile.physicsBody!.collisionBitMask = UInt32(self.meteorCategory)
            //接触できるオブジェクト（隕石）
            
            // スパーク
            do {
                let fileURL = Bundle.main.url(forResource: "Spark", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
                let fireSpark = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as! SKEmitterNode
                
                fireSpark.position = CGPoint(x: (missaile.size.width / 2) - 7,
                                             y: -(missaile.size.height / 2))
                
                //パーティクルの調整。ロケット噴射のように見せる
                fireSpark.particleLifetime = 0.1
                fireSpark.numParticlesToEmit = 50
                fireSpark.particleBirthRate = 200
                fireSpark.emissionAngle = CGFloat(-(Double.pi / 2))
                fireSpark.emissionAngleRange = 0
                fireSpark.particlePositionRange = CGVector(dx: 0,
                                                           dy: 0)
                //ロケットに配置
                missaile.addChild(fireSpark)
                
            } catch {
                print("didn't work")
            }
        }
    }
}
