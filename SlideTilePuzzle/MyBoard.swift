//
//  MyBoard.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 24/08/2017.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

class MyBoard {
  var emptyIndex = -1
  var model = [Int]()
  var lastValidMove = ""
  
  func createBoard() -> MyBoard {
    let board = MyBoard()
    var arr:[Int] = []
    for num in self.model {
      arr.append(num)
    }
    board.model = arr
    board.emptyIndex = self.emptyIndex
    
    return board
  }
  
  func shuffle() -> [Int]? {
    // empty and single-element collections don't shuffle
    var i = 0
    while i < 10000 {
      i = i + 1
      let move = arc4random_uniform(4) % 4
      switch move {
      case 0:
        self.U()
        break
      case 1:
        self.D()
        break
      case 2:
        self.R()
        break
      case 3:
        self.L()
        break
      default:
        break
      }
    }
    self.lastValidMove = ""
    return self.model
  }
  
  func doMove(move:BoardMove) {
    switch move {
    case .R:
      self.R()
      break
    case .L:
      self.L()
      break
    case .D:
      self.D()
      break
    case .U:
      self.U()
      break
    case .LUR:
      self.LUR()
      break
    case .RUL:
      self.RUL()
      break
    case .ULD:
      self.ULD()
      break
    case .RUULD:
      self.RUULD()
      break
    case .DLLUR:
      self.DLLUR()
      break
    case .DRRUL:
      self.DRRUL()
      break
    case .URRDLULD:
      self.URRDLULD()
      break
    case .UULDRDLUURD:
      self.UULDRDLUURD()
      break
    case .URDRULLDRUR:
      self.URDRULLDRUR()
      break
    case .LURRDLULD:
      self.LURRDLULD()
      break
    case .URDRRULLLDRRUR:
      self.URDRRULLLDRRUR()
      break
    case .URDRRULLLDRRURD:
      self.URDRRULLLDRRURD()
      break
    case .LLURDRRULLLDRRURD:
      self.LLURDRRULLLDRRURD()
      break
    case .ULDLLURDRULLDRRURD:
      self.ULDLLURDRULLDRRURD()
      break
    }
    
    lastValidMove = ""
  }
  
  func rateMove(move:Int, solution:Array<Any>) -> (rate:Int, move:BoardMove) {
    let start = DispatchTime.now()
    let move:BoardMove = BoardMove(rawValue: move)!
    switch move {
    case .R:
      self.R()
      break
    case .L:
      self.L()
      break
    case .D:
      self.D()
      break
    case .U:
      self.U()
      break
    case .LUR:
      self.LUR()
      break
    case .RUL:
      self.RUL()
      break
    case .ULD:
      self.ULD()
      break
    case .RUULD:
      self.RUULD()
      break
    case .DLLUR:
      self.DLLUR()
      break
    case .DRRUL:
      self.DRRUL()
      break
    case .URRDLULD:
      self.URRDLULD()
      break
    case .UULDRDLUURD:
      self.UULDRDLUURD()
      break
    case .URDRULLDRUR:
      self.URDRULLDRUR()
      break
    case .LURRDLULD:
      self.LURRDLULD()
      break
    case .URDRRULLLDRRUR:
      self.URDRRULLLDRRUR()
      break
    case .URDRRULLLDRRURD:
      self.URDRRULLLDRRURD()
      break
    case .LLURDRRULLLDRRURD:
      self.LLURDRRULLLDRRURD()
      break
    case .ULDLLURDRULLDRRURD:
      self.ULDLLURDRULLDRRURD()
      break
    }
    print("Move took = \(DispatchTime.now().rawValue - start.rawValue)")
    let startRate = DispatchTime.now()
    let result = (rate:self.rate(), move:move)
    print("Rate took = \(DispatchTime.now().rawValue - startRate.rawValue)")
    let startReverse = DispatchTime.now()
    if lastValidMove != "" {
      self.reverseMove()
    }
    print("Reverse took = \(DispatchTime.now().rawValue - startReverse.rawValue)")
    
    return result
  }
  
  func reverseMove() {
    for char in lastValidMove.characters.reversed() {
      let strChar = "\(char)"
      switch strChar {
      case "R":
        self.L()
        break
      case "L":
        self.R()
        break
      case "U":
        self.D()
        break
      case "D":
        self.U()
        break
      default:
        break
      }
      lastValidMove.characters.removeLast()
    }
    lastValidMove = ""
  }
  
  func getNumberOfUnordered() -> Int {
    var rate = 0
    for num in self.model {
      if self.model[self.model.index(of: num)!] != self.model.index(of: num)! + 1 {
        break
      }
      rate = rate + 1
    }
    
    return rate
  }
  
  func getNextStep(numI:Int) -> (nextStepDistance:Int, emptyTileDistance:Int) {
    var num = numI
    if numI == self.model.count {
      num = -1
    }
    let N = Int(sqrt(Double(self.model.count)))
    let emptyIndex:(x:Int, y:Int) = (x:(self.emptyIndex % N),
                                     y:(self.emptyIndex / N))
    
    var nextItemIndex = (x:0, y:0)
    var indexOfCorrectLocation = (x:0, y:0)
    
    //      let nextTime = DispatchTime.now()
    let arrIndex = self.model.index(of: num)!
    nextItemIndex = (x:arrIndex % N, y: Int(arrIndex / N))
    indexOfCorrectLocation = (x:Int((num - 1) % N), y: Int((num - 1) / N))
    //      print("Next = \(DispatchTime.now().rawValue - nextTime.rawValue)")
    let nextStepDistance = abs(nextItemIndex.x - indexOfCorrectLocation.x) + abs(nextItemIndex.y - indexOfCorrectLocation.y)
    let emptyTileDistance = abs(nextItemIndex.x - emptyIndex.x) + abs(nextItemIndex.y - emptyIndex.y)
    
    return (nextStepDistance:nextStepDistance, emptyTileDistance:emptyTileDistance)
  }
  
  func rate() -> Int {
    //    let iterTime = DispatchTime.now()
    let numberOfUnordered = self.getNumberOfUnordered()
    //    print("Inorder time = \(DispatchTime.now().rawValue - iterTime.rawValue)")
    let next:(nextStepDistance:Int, emptyTileDistance:Int) = self.getNextStep(numI: numberOfUnordered + 1)
    let N = sqrt(Double(self.model.count))
    
    let c1 = 4 * Int(pow(N, 2.0)) * (Int(pow(N, 2.0)) - numberOfUnordered)
    let c2 = 2 * Int(N) * (next.nextStepDistance)
    let c3 = next.emptyTileDistance
    
    return c1 + c2 + c3
  }
  
  func validateR(emptyIndex:Int, rowSize:Int) -> Bool {
    return emptyIndex != -1 && (emptyIndex + 1) / rowSize == emptyIndex / rowSize
  }
  
  func validateL(emptyIndex:Int, rowSize:Int) -> Bool {
    return emptyIndex != -1 && emptyIndex != 0 && (emptyIndex - 1) / rowSize == emptyIndex / rowSize
  }
  
  func validateU(emptyIndex:Int, rowSize:Int) -> Bool {
    return emptyIndex != -1 && emptyIndex - rowSize >= 0
  }
  
  func validateD(emptyIndex:Int, rowSize:Int) -> Bool {
    return emptyIndex != -1 && emptyIndex + rowSize < self.model.count
  }
  
  func validateLUR(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateL(emptyIndex: emptyIndex, rowSize: rowSize),
      validateU(emptyIndex: emptyIndex - 1, rowSize: rowSize) {
      return true
    }
    
    return false
  }
  
  func validateRUL(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateR(emptyIndex: emptyIndex, rowSize: rowSize),
      validateU(emptyIndex: emptyIndex + 1, rowSize: rowSize) {
      return true
    }
    
    return false
  }
  
  func validateULD(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateU(emptyIndex: emptyIndex, rowSize: rowSize),
      validateL(emptyIndex: emptyIndex - rowSize, rowSize: rowSize) {
      return true
    }
    
    return false
  }
  
  func validateRUULD(emptyIndex:Int, rowSize:Int) -> Bool {
    if self.validateR(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex + 1 - rowSize * 2) > 0 {
      return true
    }
    
    return false
  }
  
  func validateDLLUR(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateD(emptyIndex: emptyIndex, rowSize: rowSize),
      ((emptyIndex + rowSize - 2) / rowSize) == (emptyIndex + rowSize) / rowSize {
      return true
    }
    
    return false
  }
  
  func validateDRRUL(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateD(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex + rowSize + 2) / rowSize == (emptyIndex + rowSize) / rowSize {
      return true
    }
    
    return false
  }
  
  func validateURRDLULD(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateU(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex - rowSize + 2) / rowSize == (emptyIndex - rowSize) / rowSize {
      return true
    }
    
    return false
  }
  
  func validateUULDRDLUURD(emptyIndex:Int, rowSize:Int) -> Bool {
    if emptyIndex != -1, (emptyIndex - 2 * rowSize) > 0,
      self.validateL(emptyIndex: emptyIndex - 2 * rowSize, rowSize: rowSize) {
      return true
    }
    
    return false
  }
  
  func validateLURRDLULD(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateL(emptyIndex: emptyIndex, rowSize: rowSize),
      validateU(emptyIndex: emptyIndex - 1, rowSize: rowSize),
      (emptyIndex - 1 - rowSize + 2) / rowSize == (emptyIndex - 1 - rowSize) / rowSize {
      return true
    }
    
    return false
  }
  
  func validateURDRRULLLDRRUR(emptyIndex:Int, rowSize:Int) -> Bool {
    if self.validateU(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex - rowSize + 3) / rowSize == (emptyIndex - rowSize) / rowSize {
      return true
    }
    
    return false
  }
  
  func validateURDRULLDRUR(emptyIndex: Int, rowSize: Int) -> Bool {
    if self.validateU(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex + 2) / rowSize == emptyIndex / rowSize {
      return true
    }
    
    return false
  }
  
  func validateURDRRULLLDRRURD(emptyIndex:Int, rowSize:Int) -> Bool {
    return validateURDRRULLLDRRUR(emptyIndex: emptyIndex, rowSize: rowSize)
  }
  
  func validateLLURDRRULLLDRRURD(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateR(emptyIndex: emptyIndex, rowSize: rowSize),
      validateU(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex - 2) / rowSize == emptyIndex / rowSize {
      return true
    }
    return false
  }
  
  func validateULDLLURDRULLDRRURD(emptyIndex:Int, rowSize:Int) -> Bool {
    if validateR(emptyIndex: emptyIndex, rowSize: rowSize),
      (emptyIndex - 3)/rowSize == emptyIndex/rowSize {
      return true
    }
    
    return false
  }
  
  func ULDLLURDRULLDRRURD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateULDLLURDRULLDRRURD(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.U()
      self.L()
      self.D()
      self.L()
      self.L()
      self.U()
      self.R()
      self.D()
      self.R()
      self.U()
      self.L()
      self.L()
      self.D()
      self.R()
      self.R()
      self.U()
      self.R()
      self.D()
    }
  }
  
  func LLURDRRULLLDRRURD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if self.validateLLURDRRULLLDRRURD(emptyIndex:emptyIndex, rowSize: rowSize) {
      
      self.L()
      self.L()
      self.URDRRULLLDRRUR()
      self.D()
    }
  }
  
  func URDRRULLLDRRURD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if self.validateURDRRULLLDRRURD(emptyIndex:emptyIndex, rowSize: rowSize) {
      
      self.URDRRULLLDRRUR()
      self.D()
    }
  }
  
  func URDRRULLLDRRUR() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateURDRRULLLDRRUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.U()
      self.R()
      self.D()
      self.R()
      self.R()
      self.U()
      self.L()
      self.L()
      self.L()
      self.D()
      self.R()
      self.R()
      self.U()
      self.R()
    }
  }
  
  func URDRULLDRUR() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateURDRULLDRUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.U()
      self.R()
      self.D()
      self.R()
      self.U()
      self.L()
      self.L()
      self.D()
      self.R()
      self.U()
      self.R()
    }
  }
  
  func LURRDLULD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateLURRDLULD(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.L()
      self.U()
      self.R()
      self.R()
      self.D()
      self.L()
      self.U()
      self.L()
      self.D()
    }
  }
  
  func UULDRDLUURD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateUULDRDLUURD(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.U()
      self.U()
      self.L()
      self.D()
      self.R()
      self.D()
      self.L()
      self.U()
      self.U()
      self.R()
      self.D()
    }
  }
  
  func URRDLULD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateURRDLULD(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.U()
      self.R()
      self.R()
      self.D()
      self.L()
      self.U()
      self.L()
      self.D()
    }
  }
  
  func DRRUL() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateDRRUL(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.D()
      self.R()
      self.R()
      self.U()
      self.L()
    }
  }
  
  func DLLUR() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateDLLUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.D()
      self.L()
      self.L()
      self.U()
      self.R()
    }
  }
  
  func RUULD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateRUULD(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.R()
      self.U()
      self.U()
      self.L()
      self.D()
    }
  }
  
  func ULD() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateULD(emptyIndex: emptyIndex, rowSize: rowSize) {
      
      self.U()
      self.L()
      self.D()
    }
  }
  
  func RUL() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateRUL(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.R()
      self.U()
      self.L()
    }
  }
  
  func LUR() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateLUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.L()
      self.U()
      self.R()
    }
  }
  
  func R() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateR(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "R"
      lastValidMove = lastValidMove + "R"
      self.swap(empty:emptyIndex, index: emptyIndex + 1)
    }
  }
  
  func L() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateL(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "L"
      lastValidMove = lastValidMove + "L"
      self.swap(empty:emptyIndex, index: emptyIndex - 1)
    }
  }
  
  func U() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateU(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "U"
      lastValidMove = lastValidMove + "U"
      self.swap(empty:emptyIndex, index: emptyIndex - rowSize)
    }
  }
  
  func D() {
    let rowSize = Int(sqrt(Double(self.model.count)))
    if validateD(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "D"
      lastValidMove = lastValidMove + "D"
      self.swap(empty:emptyIndex, index: emptyIndex + rowSize)
    }
  }
  
  func swap(empty:Int, index:Int) {
    let tmp = self.model[empty]
    self.model[empty] = self.model[index]
    self.emptyIndex = index
    self.model[index] = tmp
  }
  
}
