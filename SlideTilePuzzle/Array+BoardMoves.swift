//
//  Array+BoardMoves.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/13/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

class Shuffle {
  var shuffled = ""
  var lastValidMove = ""
  var solving:Bool = false
  
  static func +(shuffled:Shuffle, string:String) -> Shuffle {
    if shuffled.solving {
      return shuffled
    }
    
    if shuffled.shuffled.characters.count == 0 {
      shuffled.shuffled = string
      return shuffled
    }
    
    let lastOp = "\(shuffled.shuffled.characters.last!)"
    switch(lastOp) {
    case "U":
      if string == "D" {
        shuffled.shuffled.characters.removeLast()
      } else {
        shuffled.shuffled = shuffled.shuffled + string
      }
      break
    case "D":
      if string == "U" {
        shuffled.shuffled.characters.removeLast()
      } else {
        shuffled.shuffled = shuffled.shuffled + string
      }
      break
    case "L":
      if string == "R" {
        shuffled.shuffled.characters.removeLast()
      } else {
        shuffled.shuffled = shuffled.shuffled + string
      }
      break
    case "R":
      if string == "L" {
        shuffled.shuffled.characters.removeLast()
      } else {
        shuffled.shuffled = shuffled.shuffled + string
      }
      break
    default:
      break
    }
    return shuffled
  }
  
  func solution() -> String {
    var path = ""
    for char in shuffled.characters.reversed() {
      let strChar = "\(char)"
      switch strChar {
      case "U":
        path = path + "D"
        break
      case "D":
        path = path + "U"
        break
      case "R":
        path = path + "L"
        break
      case "L":
        path = path + "R"
        break
      default:
        break
      }
    }
    
    return path
  }
}

class Utils {
  static let shared:Utils = Utils()
  var shuffled:Shuffle = Shuffle()
}

private var emptyIndex1 = -1
private var next = 1
extension Array {
  var emptyIndex:Int {
    get {
      return emptyIndex1
    }
    set {
      emptyIndex1 = newValue
    }
  }
  
  
  
  mutating func doMove(move:BoardMove) {
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
    
    Utils.shared.shuffled.lastValidMove = ""
  }
  
  mutating func rateMove(move:Int) -> (rate:Int, move:BoardMove) {
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
    
    let result = (rate:self.rate(), move:move)
    if Utils.shared.shuffled.lastValidMove != "" {
      self.reverseMove()
    }
    
    return result
  }
  
  mutating func reverseMove() {
    for char in Utils.shared.shuffled.lastValidMove.characters.reversed() {
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
      Utils.shared.shuffled.lastValidMove.characters.removeLast()
    }
    Utils.shared.shuffled.lastValidMove = ""
  }
  
  func getNumberOfUnordered() -> Int {
    var rate = 0
    var arr = self as! [Int]
    for num in arr {
      if arr[arr.index(of: num)!] != arr.index(of: num)! + 1 {
        break
      }
      rate = rate + 1
    }
    
    return rate
  }
  
  func getNextStep(numI:Int) -> (nextStepDistance:Int, emptyTileDistance:Int) {
    var num = numI
    if numI == self.count {
      num = -1
    }
    let N = Int(sqrt(Double(self.count)))
    let emptyIndex:(x:Int, y:Int) = (x:(getEmptyIndex() % N),
                                     y:(getEmptyIndex() / N))
    
    var nextItemIndex = (x:0, y:0)
    var indexOfCorrectLocation = (x:0, y:0)
    if let arr = self as? Array<Int> {
//      let nextTime = DispatchTime.now()
      let arrIndex = arr.index(of: num)!
      nextItemIndex = (x:arrIndex % N, y: Int(arrIndex / N))
      indexOfCorrectLocation = (x:Int((num - 1) % N), y: Int((num - 1) / N))
//      print("Next = \(DispatchTime.now().rawValue - nextTime.rawValue)")
      let nextStepDistance = abs(nextItemIndex.x - indexOfCorrectLocation.x) + abs(nextItemIndex.y - indexOfCorrectLocation.y)
      let emptyTileDistance = abs(nextItemIndex.x - emptyIndex.x) + abs(nextItemIndex.y - emptyIndex.y)
      
      return (nextStepDistance:nextStepDistance, emptyTileDistance:emptyTileDistance)
    }
    
    return (nextStepDistance:0, emptyTileDistance:0)
    
  }
  
  func rate() -> Int {
//    let iterTime = DispatchTime.now()
    let numberOfInordered = self.getNumberOfUnordered()
//    print("Inorder time = \(DispatchTime.now().rawValue - iterTime.rawValue)")
    let next:(nextStepDistance:Int, emptyTileDistance:Int) = self.getNextStep(numI: numberOfInordered + 1)
    let N = sqrt(Double(self.count))
    
    let c1 = 4 * Int(pow(N, 2.0)) * (Int(pow(N, 2.0)) - numberOfInordered)
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
    return emptyIndex != -1 && emptyIndex + rowSize < self.count
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
  
  mutating func ULDLLURDRULLDRRURD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
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
  
  mutating func LLURDRRULLLDRRURD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if self.validateLLURDRRULLLDRRURD(emptyIndex:emptyIndex, rowSize: rowSize) {
      
      self.L()
      self.L()
      self.URDRRULLLDRRUR()
      self.D()
    }
  }
  
  mutating func URDRRULLLDRRURD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if self.validateURDRRULLLDRRURD(emptyIndex:emptyIndex, rowSize: rowSize) {
      
      self.URDRRULLLDRRUR()
      self.D()
    }
  }
  
  mutating func URDRRULLLDRRUR() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
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
  
  mutating func URDRULLDRUR() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
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
  
  mutating func LURRDLULD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
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
  
  mutating func UULDRDLUURD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
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
  
  mutating func URRDLULD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
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
  
  mutating func DRRUL() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateDRRUL(emptyIndex: emptyIndex, rowSize: rowSize) {
      
      self.D()
      self.R()
      self.R()
      self.U()
      self.L()
    }
  }
  
  mutating func DLLUR() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateDLLUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      
      self.D()
      self.L()
      self.L()
      self.U()
      self.R()
    }
  }
  
  mutating func RUULD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateRUULD(emptyIndex: emptyIndex, rowSize: rowSize) {
      
      self.R()
      self.U()
      self.U()
      self.L()
      self.D()
    }
  }
  
  mutating func ULD() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateULD(emptyIndex: emptyIndex, rowSize: rowSize) {
      
      self.U()
      self.L()
      self.D()
    }
  }
  
  mutating func RUL() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateRUL(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.R()
      self.U()
      self.L()
    }
  }
  
  mutating func LUR() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateLUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      self.L()
      self.U()
      self.R()
    }
  }
  
  mutating func R() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.emptyIndex
    if validateR(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "R"
      Utils.shared.shuffled.lastValidMove = Utils.shared.shuffled.lastValidMove + "R"
      self.swap(empty:emptyIndex, index: emptyIndex + 1)
    }
  }
  
  mutating func L() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateL(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "L"
      Utils.shared.shuffled.lastValidMove = Utils.shared.shuffled.lastValidMove + "L"
      self.swap(empty:emptyIndex, index: emptyIndex - 1)
    }
  }
  
  mutating func U() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateU(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "U"
      Utils.shared.shuffled.lastValidMove = Utils.shared.shuffled.lastValidMove + "U"
      self.swap(empty:emptyIndex, index: emptyIndex - rowSize)
    }
  }
  
  mutating func D() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateD(emptyIndex: emptyIndex, rowSize: rowSize) {
      Utils.shared.shuffled = Utils.shared.shuffled + "D"
      Utils.shared.shuffled.lastValidMove = Utils.shared.shuffled.lastValidMove + "D"
      self.swap(empty:emptyIndex, index: emptyIndex + rowSize)
    }
  }
  
  func getEmptyIndex() -> Int {
    return self.emptyIndex
  }
  
  func nextNum() -> Int {
    return next
  }
  
  func advanceNum() {
    next = next + 1
  }
  
  mutating func swap(empty:Int, index:Int) {
    let tmp = self[empty]
    self[empty] = self[index]
    self.emptyIndex = index
    self[index] = tmp
  }
}
