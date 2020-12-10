//
//  GameSceneDidSimulatePhysics.swift
//  TestSwift
//
//  Created by aship on 2020/11/11.
//

import SpriteKit

extension GameScene {
    override func didSimulatePhysics() {
        // print("PHYSICSSSS")
        
        //プレイヤーカーを検索
        let road: SKNode = self.childNode(withName: kRoadName)!
        let playerCar: SKSpriteNode = ((road.childNode(withName: kPlayerCarName) as? SKSpriteNode)!)
        
        //プレイヤーカーの回転角からベクトルを求める
        let x: CGFloat = sin(playerCar.zRotation)
        let y: CGFloat = cos(playerCar.zRotation)
        
        
        
        if _acceleON {
            //加速
            _accelete += 10
            
            
            if _accelete > 500 {
                _accelete = 500
            }
            
            //    print("PHYSICSSSS _accelete \(_accelete)")
            
            
        } else {
            //減速
            _accelete -= 10
            if _accelete < 0 {
                _accelete = 0
            }
            
        }
        
        //   print("PHYSICSSSS 2")
        
        
        //ベクトルを加える
        playerCar.physicsBody!.velocity = CGVector(dx: -(_accelete * x),
                                                   dy: (_accelete * y))
        //プレイヤーカーの位置に合わせてオートスクロール
        //シーン上でのレーシングカーの座標を道路ノードからの位置に変換
        let pt: CGPoint = self.convert(playerCar.position, from: road)
        
        // シーン上で道路ノードの位置を変更する
        // これコメントアウトすると車だけ上行く
        road.position = CGPoint(x: 0,
                                y: Int(road.position.y - pt.y) + playerOffsetY)
        
        ///  print("PHYSICSSSS car.position \(playerCar.position)")
        // print("PHYSICSSSS playerCar.physicsBody!.velocity \(playerCar.physicsBody!.velocity)")
        
        //  let height: CGFloat = self.size.height
        
        // 道路入れ替え
        road.enumerateChildNodes(withName: kRoadViewName) { node, stop in
            let pt: CGPoint = road.convert(node.position, to: self)
            
            //  print("pt.y \(pt.y)")
            //  print("node.frame.size.height \(node.frame.size.height)")
            // 完全に見えなるなるまでの距離
            let disappearDistance = screenHeight / 2 + node.frame.size.height / 2
            
            if pt.y < -1 * disappearDistance {
                // 3つぶん上に行く(間に2つあるから)
                let moveDistance = node.position.y + node.frame.size.height * CGFloat(self.numberOfRoad)
                
                node.position = CGPoint(x: 0,
                                        y: moveDistance)
            }
        }
        
        // 壁入れ替え
        road.enumerateChildNodes(withName: kWallName) { node, stop in
            let pt: CGPoint = road.convert(node.position, to: self)
            
            // 完全に見えなるなるまでの距離
            let disappearDistance = screenHeight / 2 + node.frame.size.height / 2
            
            if pt.y < -1 * disappearDistance {
                // 3つぶん上に行く(間に2つあるから)
                let moveDistance = node.position.y + node.frame.size.height * CGFloat(self.numberOfWall)
                
                node.position = CGPoint(x: node.position.x,
                                        y: moveDistance)
                node.zRotation = 0
            }
        }
        
        // その他の車
        road.enumerateChildNodes(withName: kOtherCarName) { node, stop in
            let pt: CGPoint = road.convert(node.position, to: self)
            
            //   print("ENEMY pt.y \(pt.y)")
            
            if pt.y < -1.5 * screenHeight || screenHeight * 1.5 < pt.y {
                //画面外の車を削除
                node.removeFromParent()
            } else {
                //ベクトルを加える
                //  var dic: [String : String] = node.userData! as! [String : String]
                
                
                
                let dx: CGFloat = node.userData!.value(forKey: "speedX") as! CGFloat
                let dy: CGFloat = node.userData!.value(forKey: "speedY") as! CGFloat
                
                //     print("dy  \(dy)")
                
                node.physicsBody!.velocity = CGVector(dx: dx, dy: dy)
                
            }
        }
        
        //走行距離
        self.distance = (playerCar.position.y-_carStartPt.y)/100
        
        let dist: SKLabelNode = ((self.childNode(withName: kDistLabelName) as? SKLabelNode)!)
        dist.text = String(format: "%.0f m", self.distance)
        
        // スピード表示
        let speedLabel: SKLabelNode = ((self.childNode(withName: kSpeedLabelName) as? SKLabelNode)!)
        speedLabel.text = String(format: "%.0f km/h", _accelete)
    }
}
