//
//  GameSceneEtc.swift
//  TestSwift
//
//  Created by aship on 2020/12/10.
//

import SpriteKit

extension GameScene {
    //スコア更新
    func setScore(_ score: Int32) {
        self.score = Int(score)
        //ラベル更新
        //名前から宇宙船を検索
        var scoreNode: SKLabelNode
        scoreNode = ((self.childNode(withName: kScoreName) as? SKLabelNode)!)
        scoreNode.text = "\(self.score)"
    }
    
    //隕石落下数
    func setFallenNumber(_ fallenNumber: Int32) {
        self.fallenNumber = Int(fallenNumber)
        
        if self.fallenNumber < 0 {
            self.fallenNumber = 0
        }
        
        //名前からラベルを検索
        let fallenNumNode: SKLabelNode = (self.childNode(withName: kFallenName) as? SKLabelNode)!
        
        //ラベル更新
        fallenNumNode.text = "\(self.fallenNumber)"
        
        if self.fallenNumber <= 0 {
            self.showGameOver()
            //ゲームオーバー
        }
    }
    
    //ゲームオーバー
    func showGameOver() {
        if _gameOver == false {
            _gameOver = true
            //ゲームオーバーフラグ
            let gameOverLabel: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.fontSize = 40
            gameOverLabel.position = CGPoint(x: self.frame.midX,
                                             y: self.frame.midY+50)
            self.addChild(gameOverLabel)
            
            //点滅アクション
            let pleaseTouch: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
            pleaseTouch.text = "Please, touch the screen"
            pleaseTouch.fontSize = 20
            pleaseTouch.position = CGPoint(x: self.frame.midX,
                                           y:80)
            self.addChild(pleaseTouch)
            
            let actions: [SKAction] = [SKAction.fadeAlpha(to: 0.0, duration: 0.75),
                                       SKAction.fadeAlpha(to: 1.0, duration: 0.75)]
            let action: SKAction = SKAction.repeatForever(SKAction.sequence(actions))
            pleaseTouch.run(action)
        }
    }
    
    
    
    //炎パーティクル作成
    func makeFireParticle(_ point: CGPoint) {
        if _particleFire == nil {
            
            do {
                let fileURL = Bundle.main.url(forResource: "Fire", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
                _particleFire = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
            } catch {
                print("didn't work")
            }
            
            
            _particleFire!.numParticlesToEmit = 50
            
            self.addChild(_particleFire!)
        } else {
            _particleFire!.resetSimulation()
            
        }
        
        _particleFire!.position = point
    }
    
    //スパークパーティクル作成
    func makeSparkParticle(_ point: CGPoint) {
        if _particleSpark == nil {
            do {
                let fileURL = Bundle.main.url(forResource: "Spark", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
                _particleSpark = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
            } catch {
                print("didn't work")
            }
            
            _particleSpark!.numParticlesToEmit = 50
            
            self.addChild(_particleSpark!)
        } else {
            _particleSpark?.resetSimulation()
            
        }
        
        _particleSpark!.position = point
    }
    
    //ボムパーティクル作成
    func makeBomParticle(_ point: CGPoint) {
        if _particleBom == nil {
            
            do {
                let fileURL = Bundle.main.url(forResource: "Bom", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
                _particleBom = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
            } catch {
                print("didn't work")
            }
            
            
            _particleBom!.numParticlesToEmit = 350
            self.addChild(_particleBom!)
        } else {
            _particleBom?.resetSimulation()
            
        }
        
        _particleBom!.position = point
    }
    
    //スモークパーティクル作成
    func makeSmokeParticle(_ point: CGPoint) {
        if _particleSmoke == nil {
            do {
                let fileURL = Bundle.main.url(forResource: "Smoke", withExtension: "sks")!
                let fileData = try Data(contentsOf: fileURL)
                _particleSmoke = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? SKEmitterNode
            } catch {
                print("didn't work")
            }
            
            _particleSmoke!.numParticlesToEmit = 100
            self.addChild(_particleSmoke!)
        } else {
            _particleBom?.resetSimulation()
        }
        
        _particleSmoke!.position = point
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    //衝突終了
    func didEnd(_ contact: SKPhysicsContact) {
    }
}
