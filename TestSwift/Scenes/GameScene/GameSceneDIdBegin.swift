//
//  GameSceneDidBegin.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        let bodyNameB: String = contact.bodyB.node!.name!
        
        //その他の車に接触
        if bodyNameB.isEqual(kOtherCarName) {
            
            //    print("DID OTHER CAR")
            
            
            let road: SKNode = self.childNode(withName: kRoadName)!
            let pt: CGPoint = self.convert(contact.contactPoint, to: road)
            self.makeFireParticle(pt)
            self.makeSmokeParticle(pt)
            //ゲームオーバー
            self.showGameOver()
        }
        
        //プレイヤーカーが壁に接触
        if bodyNameB.isEqual(kPlayerCarName) {
            
            //  print("DID OTHER WALL")
            
            
            let road: SKNode = self.childNode(withName: kRoadName)!
            let pt: CGPoint = self.convert(contact.contactPoint, to: road)
            self.makeSparkParticle(pt)
        }
    }
    
    //炎パーティクル作成
    func makeFireParticle(_ point: CGPoint) {
        if _particleFire == nil {
            let road: SKNode = self.childNode(withName: kRoadName)!
            
            do {
                let fileURL = Bundle.main.url(forResource: "Fire", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
            
                _particleFire = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
                _particleFire!.numParticlesToEmit = 350
            } catch {
                print("didn't work")
            }
            
            road.addChild(_particleFire!)
        } else {
            _particleFire!.resetSimulation()
        }
        
        _particleFire!.position = point
    }
    
    //スパークパーティクル作成
    func makeSparkParticle(_ point: CGPoint) {
        if _particleSpark == nil {
            let road: SKNode = self.childNode(withName: kRoadName)!
                        
            do {
                let fileURL = Bundle.main.url(forResource: "Spark", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
            
                _particleSpark = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
            } catch {
                print("didn't work")
            }
            
            _particleSpark!.numParticlesToEmit = 100
            road.addChild(_particleSpark!)
        } else {
            _particleSpark!.resetSimulation()
        }
        
        _particleSpark!.position = point
    }
    
    //スモークパーティクル作成
    func makeSmokeParticle(_ point: CGPoint) {
        if _particleSmoke == nil {
            let road: SKNode = self.childNode(withName: kRoadName)!
            
            do {
                let fileURL = Bundle.main.url(forResource: "Smoke", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
            
                _particleSmoke = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
            } catch {
                print("didn't work")
            }
            
            road.addChild(_particleSmoke!)
        } else {
            _particleSmoke?.resetSimulation()
        }
        
        _particleSmoke!.position = point
    }
    
    //ゲームオーバー
    func showGameOver() {
        if _gameOver == false {
            //プレイヤーカーを検索
            let road: SKNode = self.childNode(withName: kRoadName)!
            let reacingCar: SKSpriteNode = ((road.childNode(withName: kPlayerCarName) as? SKSpriteNode)!)
            
            self.physicsWorld.speed = 0
            
            //物理シミュレーション停止
            _gameOver = true
            
            //ゲームオーバーフラグ
            let gameOverLabel: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.fontSize = 30
            gameOverLabel.position = CGPoint(x: self.frame.midX,
                                             y: reacingCar.position.y + 160)
            road.addChild(gameOverLabel)
        }
    }
}
