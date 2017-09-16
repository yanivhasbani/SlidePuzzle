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
  var model = MyBoard()
  var image:Image = Image()
  var currentlyShowing:MyBoard = MyBoard()
  var solvedModel = [Int]()
  var rowSize:Int
  var solving:Bool
  var generateSolution:Bool
  var solution:(result:Bool, path:[BoardMove]) = (result:false, path:[])
  var stopped:Bool = false
  
  var delegate: BoardDelegate?
  
  init(size:Int, image:UIImage?) {
    rowSize = size
    solvedModel = (1...Int(pow(Double(size), 2)-1)).map({$0})
    model.model = solvedModel
    model.model.append(-1)
    model.emptyIndex = solvedModel.count
    model.model = model.shuffle()!
    if image != nil {
         Image.shared.shuffle(model: model.model, imageRef:image!)
    }
    currentlyShowing = model.createBoard()
    Utils.shared.shuffled.solving = true
    Utils.shared.shuffled.lastValidMove = ""
    solvedModel.append(-1)
    solving = false
    generateSolution = false
  }
  
  func boardSolved(arr:MyBoard) -> Bool {
    return arr.model == solvedModel
  }
  
  func displaySolution() {
    displayNextStep()
  }
  
  func displayNextStep() {
    if !generateSolution {
      return
    }
    
    if boardSolved(arr: self.currentlyShowing),
      let delegate = self.delegate {
      delegate.updateLabel()
      return
    }
    
    if self.takeAnotherStep(),
      let move = solution.path.first {
      self.currentlyShowing.doMove(move: move)
      if let delegate = self.delegate {
        delegate.updateCollection()
      }
      if solution.path.count > 0 {
        solution.path.removeFirst()
      }
    }
  }
  
  func getSolution() {
    generateSolution = true
    stopped = false
    DispatchQueue.global().async {
      self.displaySolution()
    }
  }
  
  func trySolving() {
    if solution.result {
      displaySolution()
      return
    }
    
    solving = true
    DispatchQueue.global().async {
      if self.takeAnotherStep() {
        self.solving = false
        if self.generateSolution {
          self.displaySolution()
        } else {
          //        assert(false, "No Solution :(")
        }
      }
    }
  }
  
  func takeAnotherStep() -> Bool {
    var best = (rate:Int.max, move:BoardMove.D)
    var result = (result:false, path:[BoardMove.D])
    result.path.remove(at: 0)
    let arr = self.model
    var currenctScore = arr.rate()
    let startAll = DispatchTime.now()
    let stepSize = 10
    while best.rate != 0 {
      if stopped {
        return false
      }
      let start = DispatchTime.now()
      let bestBefore = best
      let loopStart = DispatchTime.now()
      for move in BoardMove.U.rawValue...BoardMove.ULDLLURDRULLDRRURD.rawValue {
        let startI = DispatchTime.now()
        let iterationResult = arr.rateMove(move: move, solution:solvedModel)
        print("Rate move \(move) E= \(DispatchTime.now().rawValue - startI.rawValue)")
        if iterationResult.rate < currenctScore,
          iterationResult.rate < best.rate {
          best = iterationResult
        }
      }
      print("Loop end = \(DispatchTime.now().rawValue - loopStart.rawValue)")
      if bestBefore.rate == best.rate {
        if !self.boardSolved(arr:arr) {
          assert(false, "No Iteration")
        } else {
          break
        }
      }
      
      let appendStart = DispatchTime.now()
      solution.path.append(best.move)
      print("Append E= \(DispatchTime.now().rawValue - appendStart.rawValue)")
      currenctScore = best.rate
      let doMoveTime = DispatchTime.now()
      arr.doMove(move: best.move)
      if solution.path.count >= stepSize {
        solution.result = true
        return true
      }
      print("Do Move E= \(DispatchTime.now().rawValue - doMoveTime.rawValue)")
      print("Finished iteration time = \(DispatchTime.now().rawValue - start.rawValue)")
    }
    
    solution.result = true
    print("End = \(DispatchTime.now().rawValue - startAll.rawValue)")
    return true
  }
  
  func stop() {
    generateSolution = false
    stopped = true
  }
  
  func dismiss() {
    generateSolution = false
    stopped = true
    solution = (result:false, path:[])
    delegate?.updateLabel()
  }
  
  func swap(at:IndexPath, with: IndexPath) {
    let emptyIndex = currentlyShowing.emptyIndex
    if at.row == emptyIndex {
      currentlyShowing.swap(empty: at.row, index: with.row)
    } else if with.row == emptyIndex {
      currentlyShowing.swap(empty: with.row, index: at.row)
    } else {
      assert(false, "Wrong empty index")
    }
    model = currentlyShowing.createBoard()
  }
  
  func checkCellForMovement(at: IndexPath) -> Bool {
    if (at.row - 1 >= 0 && currentlyShowing.model[at.row - 1] == -1) ||
      (at.row + 1 < currentlyShowing.model.count && currentlyShowing.model[at.row + 1] == -1) ||
      (at.row - rowSize >= 0 && currentlyShowing.model[at.row - rowSize] == -1) ||
      (at.row + rowSize < currentlyShowing.model.count && currentlyShowing.model[at.row + rowSize] == -1) {
      return true
    }
    
    return false
  }
}
