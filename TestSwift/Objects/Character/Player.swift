//
//  Player.swift
//  AkazukinDotEat
//
//  Created by Yoshitaka Yamashita on 2/8/15.
//  Copyright (c) 2015 Yoshitaka Yamashita. All rights reserved.
//

import Foundation

// プレイヤーを表すクラス (キャラクターを継承)
class Player: Character {
    // moveメソッドをオーバライドする
    override func move() {
        // Characterクラスのmoveメソッドを呼ぶ
        super.move()
        // 花の削除をデリゲートに通知する
        delegate?.removeFlower(position: self.position)
    }
}
