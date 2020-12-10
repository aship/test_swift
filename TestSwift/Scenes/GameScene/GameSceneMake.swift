//
//  GameSceneFuncs.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

extension GameScene {
    // 整数をSkSpriteNodeにする
    func makeNumberSpriteNode(_ number: Int, numName: String?)-> SKSpriteNode {
        
        let fileName = numName ?? "num"
        //整数を文字列にして桁数を調べる
        let str = String(number)
        
        let keta = str.count
        //土台になるノードを作成する
        let sprite = SKSpriteNode()
        var con = 0
        for c in str {
            //文字列から１文字づつ取り出して画像を読み込んで配置する
            let name = fileName + String(c)
            let sp = SKSpriteNode(imageNamed: name)
            sprite.addChild(sp)
            sp.position = CGPoint(x: (CGFloat(con)*20.0)-((CGFloat(keta)*20)/2)+10, y: 0.0)
            con += 1
        }
        return sprite
    }
    
    //角度（ラジアン）と力からベクトルを返す
    func makeVector(radian: Float, power: Float)->CGVector {
        let    x = sin(CGFloat(radian))
        let    y = cos(CGFloat(radian))
        let vector: CGVector = CGVector(dx: CGFloat(power) * x, dy: CGFloat(power) * y)
        return vector
    }
    
    //２点の角度（ラジアン）を返す
    func makeRadian(center: CGPoint, toPoint: CGPoint)->CGFloat {
        
        let    radian = atan2(toPoint.y-center.y, toPoint.x-center.x)
        return    radian
    }
    
    //２点の距離を返す
    func makeLength(pt1: CGPoint, pt2: CGPoint)->CGFloat {
        
        //距離判定
        let    x = abs(pt1.x - pt2.x)
        let    y = abs(pt1.y - pt2.y)
        let    length = sqrt((x*x)+(y*y))
        //println(length)
        return    length
    }
}
