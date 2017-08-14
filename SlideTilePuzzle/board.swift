//
//  board.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
  var i = 0
  return AnyIterator {
    let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
    if next.hashValue != i { return nil }
    i += 1
    return next
  }
}

enum BoardMove {
  case U
  case D
  case L
  case R
  case LUR
  case RUL
  case ULD
  case RUULD
  case DLLUR
  case DRRUL
  case URRDLULD
  case UULDRDLUURD
  case LURRDLULD
  case URDRRULLLDRRUR
  case URDRRULLLDRRURD
  case LLURDRRULLLDRRURD
  case ULDLLURDRULLDRRURD
}

protocol BoardDelegate {
  func updateUI()
}

class Board: NSObject {
  var model = [Int]()
  var solvedModel = [Int]()
  var rowSize:Int
  var solving:Bool
  var emptyIndex:Int
  
  var delegate: BoardDelegate?
  
  init(size:Int) {
    rowSize = size
    solvedModel = (1...Int(pow(Double(size), 2)-1)).map({$0})
    model = solvedModel.shuffled()
    model.append(-1)
    solvedModel.append(-1)
    solving = false
    emptyIndex = (solvedModel.count - 1)
    solvedModel = [1,2,3,4,5,6,7,8,-1]
    model = [8,2,1,4,5,6,7,3,-1]
    emptyIndex = (solvedModel.count - 1)
  }
  
  func boardSolved() -> Bool {
    return model == solvedModel
  }
  
  func solve() {
    solving = true
    DispatchQueue.global().async {
      while (!self.boardSolved()) {
        if self.solving {
          self.takeAnotherStep()
        }
      }
    }
  }
  
  func takeAnotherStep() {
    var best = (rate:Int.max, board:[Int]())
    for move in iterateEnum(BoardMove.self) {
      let result = model.rateMove(move: move, solved: solvedModel)
      if result.rate < best.rate {
        best = result
      }
    }
    
    model = best.board
    if let delegate = self.delegate {
      delegate.updateUI()
    }
  }
  
  func stop() {
    solving = false
  }
  
  func swap(at:IndexPath, with: IndexPath) {
    if (at.row == emptyIndex) {
      emptyIndex = with.row
    } else if  (with.row == emptyIndex) {
      emptyIndex = at.row
    } else {
      assert(false, "Wrong swapping!")
    }
    let tmp = model[at.row]
    model[at.row] = model[with.row]
    model[with.row] = tmp
  }
  
  func checkCellForMovement(at: IndexPath) -> Bool {
    if (at.row - 1 >= 0 && model[at.row - 1] == -1) ||
      (at.row + 1 < model.count && model[at.row + 1] == -1) ||
      (at.row - rowSize >= 0 && model[at.row - rowSize] == -1) ||
      (at.row + rowSize < model.count && model[at.row + rowSize] == -1) {
      return true
    }
    
    return false
  }
}
