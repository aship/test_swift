//
//  Array2D.swift
//  AppleReversi
//
//  Created by Tomochika Hara on 2015/02/22.
//  Copyright (c) 2015年 Tomochika Hara. All rights reserved.
//

import Foundation

/// 二次元配列
/// SequenceTypeプロトコルを実装することでfor in ループでArrayのように扱うことができる
struct Array2D<T>: Sequence {
    
    /// 行数
    let rows: Int
    /// 列数
    let columns: Int
    /// 二次元配列の行優先順で格納した一次元配列
    fileprivate var array: [T?]
    
    /// 行と列を指定して、新規インスタンスを構築する
    init(rows: Int, columns: Int, repeatedValue: T? = nil) {
        self.rows = rows
        self.columns = columns
        self.array = Array<T?>(repeating: repeatedValue, count: rows * columns)
    }
    
    /// 行番号と列番号を指定して、二次元配列中の要素を取得する
    subscript(row: Int, column: Int) -> T? {
        get {
            if row < 0 || self.rows <= row || column < 0 || self.columns <= column {
                return nil
            }
            let idx = row * self.columns + column
            return array[idx]
        }
        set {
            self.array[row * self.columns + column] = newValue
        }
    }
    
    /// SequenceTypeプロトコルの実装に必要
    func makeIterator() -> AnyIterator<(row: Int, column: Int, element: T)> {
        print("ITERATTORRRR")
       
        //var currentSegment = 0
        
        var nextIndex = self.array.count - 1
        
        print("self.array.count \(self.array.count)")
        print("nextIndex \(nextIndex)")
        print("------------------------")
        
    //    self.array.firstIndex(of: element)

        return AnyIterator {
            
            print("ANYITERATOR")
            print("nextIndex \(nextIndex)")
            
            print("self.rows \(self.rows)")
          //  print("row \(row)")
            


            // 行優先順の一次元配列のインデックスから行・列番号を算出
            let row: Int = nextIndex / self.rows
            let column: Int = nextIndex - row * self.rows
            
            print("row \(row) column \(column)")
            
            print("------------------------")
            
            nextIndex = nextIndex - 1
            
            if (nextIndex < 0) {
                return nil  // ループが終了する
            }
            
            return (row: row,
                    column: column,
                    element: self.array[nextIndex]!)
        }
    }
}
