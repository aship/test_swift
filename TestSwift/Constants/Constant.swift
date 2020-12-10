//
//  Constant.swift
//  TestSwift
//
//  Created by aship on 2020/12/08.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

/// マス目のサイズ
let SquareHeight: CGFloat = 45.0
let SquareWidth: CGFloat = 45.0

/// 画面中心と盤面の中心位置のy軸方向のズレ
let CentralDeltaY: CGFloat = 10.0

/// 石のイメージファイルの名前
let DiskImageNames = [
    CellState.black : "black",
    CellState.white : "white",
]
