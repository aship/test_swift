//
//  GameSceneItembox.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    // アイテムボックスを作る
    func makeItemBox(_ itemNum: Int,
                     position: CGPoint)-> SKSpriteNode {
        let box = SKSpriteNode(imageNamed: "box")
        box.userData = NSMutableDictionary(object: itemNum, forKey: "number" as NSCopying)
        box.anchorPoint = CGPoint(x: 0.5,
                                  y: 0.0)
        box.name = NodeName.itemBox.rawValue
        box.zPosition = NodeName.itemBox.zPosition()
        box.position = position        //位置
        
        // 位置がおかしいので強制セット
        box.position.y = 0
        self.baseNode.addChild(box)
        
        //物理設定
        box.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(box.size.width/2),
                                                             y: 0,
                                                             width: box.size.width,
                                                             height: box.size.height))
        box.physicsBody!.categoryBitMask = NodeName.itemBox.category()
        box.physicsBody!.collisionBitMask = NodeName.frame_ground.category()
        box.physicsBody!.allowsRotation = false
        return box
    }
    
    //MARK: アイテムを作る
    func makeItem(_ itemNum: Int, position: CGPoint)-> SKSpriteNode! {
        
        var name: String!
        var money: Int!
        switch itemNum {
        case KindOfItem.money10.rawValue:        //10コイン
            name = "coin_S"
            money = 10
        case KindOfItem.money50.rawValue:        //50コイン
            name = "coin_M"
            money = 50
        case KindOfItem.money100.rawValue:        //100コイン
            name = "coin_L"
            money = 100
        default:
            name = nil
            money = 0
        }
        var    item: SKSpriteNode!
        if name != nil {
            item = SKSpriteNode(imageNamed: name!)
            item.userData = ["number":itemNum, "money":money!]
            item.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            item.name = NodeName.item.rawValue
            item.zPosition = NodeName.item.zPosition()
            item.position = position        //位置
            self.baseNode.addChild(item!)
            //物理設定
            item.physicsBody = SKPhysicsBody(rectangleOf: item!.size, center: CGPoint(x: 0, y: item!.size.height/2))
            item.physicsBody!.categoryBitMask = NodeName.item.category()
            item.physicsBody!.collisionBitMask = NodeName.frame_ground.category()
            item.physicsBody!.allowsRotation = false
        }
        return item
    }
}
