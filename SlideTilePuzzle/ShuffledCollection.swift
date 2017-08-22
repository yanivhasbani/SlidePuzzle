//
//  ShuffledCollection.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() -> [Int]? {
        // empty and single-element collections don't shuffle
        if var arr = self as? [Int] {
            var i = 0
            while i < 10000 {
                i = i + 1
                let move = arc4random_uniform(4) % 4
                switch move {
                case 0:
                    arr.U()
                    break
                case 1:
                    arr.D()
                    break
                case 2:
                    arr.R()
                    break
                case 3:
                    arr.L()
                    break
                default:
                    break
                }
            }
            return arr
        }
        
        return []
    }
}
