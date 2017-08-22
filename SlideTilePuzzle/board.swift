//
//  board.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

enum BoardMove:Int {
  case U = 0
  case D = 1
  case L = 2
  case R = 3
  case LUR = 4
  case RUL = 5
  case ULD = 6
  case DRRUL = 7
  case DLLUR = 8
  case RUULD = 9
  case URRDLULD = 10
  case LURRDLULD = 11
  case UULDRDLUURD = 12
  case URDRULLDRUR = 13
  case URDRRULLLDRRUR = 14
  case URDRRULLLDRRURD = 15
  case LLURDRRULLLDRRURD = 16
  case ULDLLURDRULLDRRURD = 17
}

protocol BoardDelegate {
  func updateCollection()
  func updateLabel()
}

class Board: NSObject {
  var model = [Int]()
  var solvedModel = [Int]()
  var rowSize:Int
  var solving:Bool
  var generateSolution:Bool
  var solution:(result:Bool, path:[BoardMove]) = (result:false, path:[])
  
  var delegate: BoardDelegate?
  
  init(size:Int) {
    rowSize = size
    solvedModel = (1...Int(pow(Double(size), 2)-1)).map({$0})
    model = solvedModel
    model.append(-1)
    model.emptyIndex = solvedModel.count
    sleep(1)
    model = model.shuffle()!
    Utils.shared.shuffled.solving = true
    solvedModel.append(-1)
    solving = false
    generateSolution = false
  }
  
  func boardSolved() -> Bool {
    return model == solvedModel
  }
  
  func displaySolution() {
    var tmpSolution = solution
    for move in solution.path.reversed() {
      if self.generateSolution == false {
        self.solution = tmpSolution
        return
      }
      self.model.doMove(move: move)
      if let delegate = self.delegate {
        delegate.updateCollection()
      }
      tmpSolution.path.remove(at: (tmpSolution.path.count - (1+tmpSolution.path.reversed().index(of: move)!)))
      sleep(1)
    }
    if let delegate = self.delegate {
      delegate.updateLabel()
    }
  }
  
  func getSolution() {
    generateSolution = true
    DispatchQueue.global().async {
      self.trySolving()
    }
  }
  
  func trySolving() {
    if solving {
      return
    }
    
    if solution.result {
      displaySolution()
    }
    
    solving = true
    DispatchQueue.global().async {
      if let solvedMoves = self.takeAnotherStep() {
        self.solving = false
        self.solution = solvedMoves
        if self.generateSolution {
          self.displaySolution()
        }
      } else {
//        assert(false, "No Solution :(")
      }
    }
  }
  
  func takeAnotherStep() -> (result:Bool, path:[BoardMove])? {
    var best = (rate:Int.max, board:[Int](), move:BoardMove.D)
    var result = (result:false, path:[BoardMove.D])
    result.path.remove(at: 0)
    while best.rate != 0 {
      let bestBefore = best
      let arr = self.model
      let currenctScore = arr.rate(arr: arr, solved: solvedModel)
      for move in BoardMove.U.rawValue...BoardMove.ULDLLURDRULLDRRURD.rawValue {
        let result = arr.rateMove(move: move, solved: solvedModel)
        if result.rate < currenctScore {
          if result.rate < best.rate {
            best = result
          }
        }
      }
      if bestBefore.rate == best.rate {
         if !self.boardSolved() {
          assert(false, "No Iteration")
         } else {
          break
        }
      }
      
      result.path.append(best.move)
      self.model.doMove(move: best.move)
    }
    
    result.result = true
    return result
  }
  
  func stop() {
    generateSolution = false
  }
  
  func swap(at:IndexPath, with: IndexPath) {
    let emptyIndex = model.emptyIndex
    if at.row != emptyIndex, with.row != emptyIndex {
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
