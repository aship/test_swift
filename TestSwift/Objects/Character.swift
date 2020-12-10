//
//  Character.swift
//  AkazukinDotEat
//
//  Created by Yoshitaka Yamashita on 2/8/15.
//  Copyright (c) 2015 Yoshitaka Yamashita. All rights reserved.
//

import Foundation
import SpriteKit

// キャラクターとシーンの橋渡しをするプロトコル
protocol CharacterDelegate {
    // キャラクターが動いたことを通知する
    func moveCharacter(character:Character)
    // 花を摘んだことを通知する
    func removeFlower(position:TilePosition)
    // 指定した位置のタイルを取得する
    func tileByPosition(position:TilePosition) -> Tile?
}

// キャラクターを表すクラス
class Character: NSObject {
    // キャラクタのスプライト
    var sprite: SKSpriteNode?
    
    // 現在の進行方向
    var direction = Direction.None
    // 次回の進行方向
    var nextDirection = Direction.None
    // 現在の位置
    var position = TilePosition(x: 0, y: 0)
    
    // 移動用タイマー
    var timer: Timer?
    // 移動する間隔(秒)
    let timerInterval = 0.6
    
    // キャラクターで起きたイベントを通知するデリゲート
    var delegate: CharacterDelegate?
    
    // キャラクターが移動可能かどうかを返すメソッド
    func canMove(position:TilePosition) -> Bool {
        // 移動先のタイルを取得する
        if let tile = self.delegate?.tileByPosition(position: position) {
            // タイルが移動可能なものかどうかを返す
            return tile.type.canMove()
        }
        return false
    }
    
    // キャラクターが方向転換可能かどうかを返すメソッド
    func canRotate(direction:Direction) -> Bool {
        // 方向転換したときの位置を求める
        let position = self.position.movedPosition(direction: direction)
        // 位置からタイルを取得する
        if let tile = self.delegate?.tileByPosition(position: position) {
            // タイルが移動可能なものかどうかを返す
            return tile.type.canMove()
        }
        return false
    }
    
    // 移動用タイマーを開始する
    func startMoving() {
        if self.timer == nil {
            // タイマーの作成
            self.timer = Timer.scheduledTimer(timeInterval: timerInterval,
                                              target: self,
                                              selector: #selector(self.timerTick),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    
    // 移動用タイマーを停止する
    func stopMoving() {
        if let timer = self.timer {
            // タイマーの停止
            timer.invalidate()
            self.timer = nil
        }
    }
    
    // タイマーによって呼ばれるメソッド
    @objc func timerTick() {
        // moveメソッドを呼ぶ
        self.move()
    }
    
    // 移動を行うメソッド
    func move() {
        // 移動したときの位置を求める
        let position = self.position.movedPosition(direction: self.nextDirection)
        
        // 移動可能であれば
        if self.canMove(position: position) {
            // 方向と位置を反映する
            self.direction = self.nextDirection
            self.position = position
            // デリゲート(シーン)にキャラクターの移動を通知する
            delegate?.moveCharacter(character: self)
        } else {
            // 移動をやめる
            self.stopMoving()
        }
    }
}
