//
//  TitleScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/22.
//

import SpriteKit

class TitleScene: SKScene {
    let titleLabel = SKLabelNode(fontNamed: "Verdana-bold")
    let startLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.09,
                                       green: 0.15,
                                       blue: 0.3,
                                       alpha: 1)
        
        titleLabel.text = "隕石スラロームゲーム"
        titleLabel.fontSize = 30
        titleLabel.position = CGPoint(x: 0,
                                      y: 200)
        self.addChild(titleLabel)
        
        startLabel.text = "START"
        startLabel.fontSize = 20
        startLabel.position = CGPoint(x: 0,
                                      y: -200)
        self.addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let touchNode = self.atPoint(location)
            
            if touchNode == startLabel {
                let scene = GameScene()
                let transition = SKTransition.crossFade(withDuration: 1.0)
                
                self.view?.presentScene(scene,
                                        transition: transition)
            }
        }
    }
}
