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
  mutating func shuffle() {
    // empty and single-element collections don't shuffle
    if count < 2 { return }
    
    for i in startIndex ..< endIndex - 1 {
      let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
      if i != j {
        swap(&self[i], &self[j])
      }
    }
  }
}

extension Collection {
  /// Return a copy of `self` with its elements shuffled
  func shuffled() -> [Iterator.Element] {
    var list = Array(self)
    list.shuffle()
    return list
  }
}
