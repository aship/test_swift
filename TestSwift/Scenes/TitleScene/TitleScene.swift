//
//  TitleScene.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

class TitleScene: SKScene {
    let spriteNodeTitleImage = SKSpriteNode(imageNamed: "title/title_back.png")
    let spriteNodeStart = SKSpriteNode(imageNamed: "title/start.png")
    
    let soundPlayer: SoundPlayer = SoundPlayer()
    
    override func sceneDidLoad() {
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5,
                                   y: 0.5)
    }

    override func didMove(to view: SKView) {
        spriteNodeTitleImage.position = CGPoint(x: 0,
                                                y: 0)
     //   spriteNodeTitleImage.setScale(0.5)
        addChild(spriteNodeTitleImage)
        
        spriteNodeStart.position = CGPoint(x: 0,
                                           y: -200)
       // spriteNodeStart.setScale(0.5)
        addChild(spriteNodeStart)
        
        //BGM再生（音楽：魔王魂）
        let filePath: String? = Bundle.main.path(forResource: "bgm_title",
                                                 ofType: "m4a")
        if let path = filePath {
            self.soundPlayer.setBGMSound(path)
        }
    }
    // タッチしたときの処理
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let touchNode = self.atPoint(location)
            
            if touchNode == spriteNodeStart {
                self.soundPlayer.bgmStop()
                
                let scene = GameScene()
                let transition = SKTransition.crossFade(withDuration: 1.0)
                
                self.view?.presentScene(scene,
                                        transition: transition)
            }
        }
    }
}
