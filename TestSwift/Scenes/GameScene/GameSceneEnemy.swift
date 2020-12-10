//
//  GameSceneEnemy.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    //MARK: 敵を作る
    func makeEnemy(_ enemyNum: Int,
                   position: CGPoint)-> CharactorNode? {
        
        let enemy = CharactorNode(atlas: SKTextureAtlas(named: "enemy"+String(enemyNum)))
        enemy.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        enemy.name = NodeName.enemy.rawValue
        enemy.position = position
        enemy.zPosition = NodeName.enemy.zPosition()
        
        let path: NSString! = Bundle.main.path(forResource: "EnemyList",
                                               ofType: "plist")! as NSString
        
        let enemyList = NSArray(contentsOfFile: path! as String)
        
        let itemDic = enemyList![enemyNum] as! NSDictionary
        enemy.chaNumber = enemyNum
        enemy.hp = itemDic["hp"] as! CGFloat                    // HP
        enemy.attack = itemDic["attack"] as! CGFloat            // 攻撃力
        enemy.velocity = itemDic["velocity"] as! CGFloat        // 移動速度
        enemy.exp = itemDic["velocity"] as! Int                    // 経験値
        enemy.isBoss = itemDic["isBoss"] as! Bool                // ボス
        
        if enemy.isBoss {
            enemy.shootEnemyBall(2.0)    //玉発射のアクション
        }
        
        self.baseNode.addChild(enemy)
        //物理設定
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.height/2,
                                          center: CGPoint(x: 0, y: enemy.size.height/2))
        enemy.physicsBody!.categoryBitMask = NodeName.enemy.category()
        enemy.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.player.category()|NodeName.obstacle.category()
        enemy.physicsBody!.contactTestBitMask = NodeName.player.category()|NodeName.obstacle.category()
        enemy.physicsBody!.allowsRotation = false
        
        return enemy
    }
}
