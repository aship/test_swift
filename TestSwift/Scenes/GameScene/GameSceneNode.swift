//
//  GameSceneNode.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    // 配置ノードを辞書にアーカイブする
    func archiveNodes()-> NSDictionary {
        
        var enemyArry: [NSDictionary] = Array()        //敵の配列
        var obstacleArry: [NSDictionary] = Array()    //障害物の配列
        var boxArry: [NSDictionary] = Array()        //アイテムボックスの配列
        
        let dict = NSMutableDictionary()            //配置ノードをまとめる辞書
        
        let childlen = self.baseNode.children        //ノードを配列で得る
        for node in childlen {
            let name = node.name
            if name == NodeName.enemy.rawValue {
                //「敵」の配置情報を辞書に入れて配列に格納
                let enemy = node as! CharactorNode
                let num = enemy.chaNumber
                let x = enemy.position.x
                let y = enemy.position.y
                let info = ["number":num, "x":x, "y":y] as [String : Any]
                enemyArry.append(info as NSDictionary)
            }
            else if name == NodeName.obstacle.rawValue {
                //「障害物」の配置情報を辞書に入れて配列に格納
                let userData = node.userData!
                let num = userData["number"] as! Int
                let x = node.position.x
                let y = node.position.y
                let info = ["number":num, "x":x, "y":y] as [String : Any]
                obstacleArry.append(info as NSDictionary)
            }
            else if name == NodeName.itemBox.rawValue {
                //「アイテムボックス」の配置情報を辞書に入れて配列に格納
                let userData = node.userData!
                let num = userData["number"] as! Int
                let x = node.position.x
                let y = node.position.y
                let info = ["number":num, "x":x, "y":y] as [String : Any]
                boxArry.append(info as NSDictionary)
            }
        }
        //ノードの配列を辞書に格納する
        dict["enemy"] = enemyArry
        dict["obstacle"] = obstacleArry
        dict["box"] = boxArry
        
        return dict
    }
    
    // 辞書からノードを配置する
    func nodeSetup(_ dictionary: NSDictionary?) {
        // 配置をクリア
        let childlen = self.baseNode.children    //ノードを配列で得る
        
        for node in childlen {
            let name = node.name
            if    name == NodeName.enemy.rawValue ||
                    name == NodeName.obstacle.rawValue ||
                    name == NodeName.itemBox.rawValue ||
                    name == NodeName.item.rawValue{
                node.removeFromParent()    //ノードを削除
            }
        }
        
        if let dict = dictionary {
            //アイテムボックスを配置
            let boxArray = dict.object(forKey: "box") as! NSArray
            
            for obj in boxArray {
                let box = obj as! NSDictionary
                let num = box.object(forKey: "number") as! Int
                let x = box.object(forKey: "x") as! CGFloat
                let y = box.object(forKey: "y") as! CGFloat
                
                _ = self.makeItemBox(num,
                                     position: CGPoint(x: x, y: y))
            }
            
            //障害物を配置
            let obstacleArry = dict.object(forKey: "obstacle") as! NSArray
            for obj in obstacleArry {
                let obstacle = obj as! NSDictionary
                let num = obstacle.object(forKey: "number") as! Int
                let x = obstacle.object(forKey: "x") as! CGFloat
                let y = obstacle.object(forKey: "y") as! CGFloat
                
                _ = self.makeObstacle(num,
                                      position: CGPoint(x: x, y: y))
            }
            
            //敵キャラを配置
            let enemyArry = dict.object(forKey: "enemy") as! NSArray
            
            for obj in enemyArry {
                let enemy = obj as! NSDictionary
                let num = enemy.object(forKey: "number") as! Int
                let x = enemy.object(forKey: "x") as! CGFloat
                let y = enemy.object(forKey: "y") as! CGFloat
                _ = self.makeEnemy(num,
                                   position: CGPoint(x: x,
                                                     y: y))
            }
        }
    }
}
