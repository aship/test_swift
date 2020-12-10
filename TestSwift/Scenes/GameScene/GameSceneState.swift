//
//  GameSceneState.swift
//  TestSwift
//
//  Created by aship on 2020/11/10.
//

import SpriteKit

/*==========================================================
 //MARK: - 列挙型
 ==========================================================*/
//MARK: ゲームステータス
enum GameState {
    case gameReady            //ゲーム開始前
    case gamePlaying        //ゲームプレイ中
    case gameWin            //ゲームクリア
    case gameLose            //ゲームオーバー
    case gameEdit            //編集
}

//MARK: ノードの名前
enum NodeName: String {
    
    case frame_ground = "frame_ground"    //地面あたり
    case backGround = "backGround"        //背景
    case middleGround = "middleGround"    //中景
    case ground = "ground"                //地面
    case player = "player"                //プレイヤー
    case arrow = "arrow"                //矢
    case enemy = "enemy"                //敵
    case obstacle = "obstacle"            //障害物
    case itemBox = "itemBox"            //アイテムボックス
    case item = "item"                    //アイテム
    case enemyBall = "enemyBall"        //敵の玉
    
    //接触カテゴリビットマスク
    func category()->UInt32{
        switch self {
        case .frame_ground:    //地面あたり
            return 0x00000001 << 0
        case .player:        //プレイヤー
            return 0x00000001 << 1
        case .arrow:        //矢
            return 0x00000001 << 2
        case .enemy:        //敵
            return 0x00000001 << 3
        case .obstacle:        //障害物
            return 0x00000001 << 4
        case .itemBox:        //アイテムボックス
            return 0x00000001 << 5
        case .item:            //アイテム
            return 0x00000001 << 6
        case .enemyBall:    //敵の玉
            return 0x00000001 << 7
        default:
            return 0x00000000
        }
    }
    //zPosition値
    func zPosition()->CGFloat {
        switch self {
        case .backGround:    //背景
            return 0
        case .middleGround:    //中景
            return 1
        case .ground:        //地面
            return 2
        case .player:        //プレイヤー
            return 10
        case .arrow, .enemyBall:    //矢, 敵の玉
            return 8
        case .enemy:        //敵
            return 10
        case .obstacle:        //障害物
            return 8
        case .itemBox:        //アイテムボックス
            return 8
        case .item:            //アイテム
            return 8
        default:
            return 0
        }
    }
}

//MARK: アイテムの種類
enum KindOfItem: Int {
    
    case non                = 0            //なし
    
    case money10            = 1            //コイン10
    case money50            = 2            //コイン50
    case money100            = 3            //コイン100
}


/*==========================================================
 //MARK: - プロトコル
 ==========================================================*/
//ゲームシーン通知デリゲート
protocol GameSceneDelegate {
    
    func gameSceneNotificationTimeCountDown(_ sec: Int)        //残り時間通知
    func gameSceneNotificationArrowCount(_ arrows: Int)        //矢の数通知
    func gameSceneNotificationArrowHitAvr(_ hitAvr: Float)    //矢ヒット率通知
    func gameSceneNotificationTakeExp(_ exp: Int)                //経験値獲得通知
    func gameSceneNotificationTakeMoney(_ money: Int)            //コイン獲得通知
    func gameSceneNotificationToResult()                    //リザルト画面への推移を通知する
    func gameSceneNotificationGameStart()                    //ゲーム開始を通知する
    func gameSceneNotificationGameOver()                    //ゲームオーバーを通知する
    func gameSceneNotificationGameClear()                    //ゲームクリアを通知する
}

