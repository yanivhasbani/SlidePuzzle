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
  var moves:[(rate:Int, board:[Int], move:BoardMove)] = []
  var possibleMoves:[[(rate:Int, board:[Int], move:BoardMove)]] = []
}

extension Array {
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
  }
  
  func rateMove(move:Int, solved:[Int]) -> (rate:Int, board:[Int], move:BoardMove) {
    let move:BoardMove = BoardMove(rawValue: move)!
    var arr = self as! [Int]
    switch move {
    case .R:
      arr.R()
      break
    case .L:
      arr.L()
      break
    case .D:
      arr.D()
      break
    case .U:
      arr.U()
      break
    case .LUR:
      arr.LUR()
      break
    case .RUL:
      arr.RUL()
      break
    case .ULD:
      arr.ULD()
      break
    case .RUULD:
      arr.RUULD()
      break
    case .DLLUR:
      arr.DLLUR()
      break
    case .DRRUL:
      arr.DRRUL()
      break
    case .URRDLULD:
      arr.URRDLULD()
      break
    case .UULDRDLUURD:
      arr.UULDRDLUURD()
      break
    case .URDRULLDRUR:
      arr.URDRULLDRUR()
      break
    case .LURRDLULD:
      arr.LURRDLULD()
      break
    case .URDRRULLLDRRUR:
      arr.URDRRULLLDRRUR()
      break
    case .URDRRULLLDRRURD:
      arr.URDRRULLLDRRURD()
      break
    case .LLURDRRULLLDRRURD:
      arr.LLURDRRULLLDRRURD()
      break
    case .ULDLLURDRULLDRRURD:
      arr.ULDLLURDRULLDRRURD()
      break
    }
    
    return (rate:self.rateInternal(arr:arr, solved: solved), board:arr, move:move)
  }
  
  private func rateInternal(arr:[Int], solved:[Int]) -> Int {
    let beforeChange = self as! [Int]
    if arr == beforeChange {
      return Int.max
    }
    return self.rate(arr: arr, solved: solved)
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
  
  func getNextStep() -> (nextStepDistance:Int, emptyTileDistance:Int) {
    let N = Int(sqrt(Double(self.count)))
    let emptyIndex:(x:Int, y:Int) = (x:(getEmptyIndex() % N),
                                     y:(getEmptyIndex() / N))
    
    var nextItemIndex = (x:0, y:0)
    var indexOfCorrectLocation = (x:0, y:0)
    if let arr = self as? Array<Int> {
      for num in 1...Int(pow(Double(N),2)) - 1 {
        if num != arr.index(of: num)! + 1 {
          nextItemIndex = (x:Int(arr.index(of: num)! % N), y: Int(arr.index(of: num)! / N))
          indexOfCorrectLocation = (x:Int((num - 1) % N), y: Int((num - 1) / N))
          break
        }
      }
      let nextStepDistance = abs(nextItemIndex.x - indexOfCorrectLocation.x) + abs(nextItemIndex.y - indexOfCorrectLocation.y)
      let emptyTileDistance = abs(nextItemIndex.x - emptyIndex.x) + abs(nextItemIndex.y - emptyIndex.y)
      
      return (nextStepDistance:nextStepDistance, emptyTileDistance:emptyTileDistance)
    }
    
    return (nextStepDistance:0, emptyTileDistance:0)
    
  }
  
  func rate(arr:[Int], solved:[Int]) -> Int {
    let numberOfInordered = arr.getNumberOfUnordered()
    let next:(nextStepDistance:Int, emptyTileDistance:Int) = arr.getNextStep()
    let N = sqrt(Double(arr.count))
    
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
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
      self.URDRRULLLDRRUR()
      self.D()
    }
  }
  
  mutating func URDRRULLLDRRUR() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateURDRRULLLDRRUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
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
      print("valid \(#function)")
      self.U()
      self.L()
      self.D()
    }
  }
  
  mutating func RUL() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateRUL(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      self.R()
      self.U()
      self.L()
    }
  }
  
  mutating func LUR() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateLUR(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      self.L()
      self.U()
      self.R()
    }
  }
  
  mutating func R() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateR(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      Utils.shared.shuffled = Utils.shared.shuffled + "R"
      self.swap(empty:emptyIndex, index: emptyIndex + 1)
    }
  }
  
  mutating func L() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateL(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      Utils.shared.shuffled = Utils.shared.shuffled + "L"
      self.swap(empty:emptyIndex, index: emptyIndex - 1)
    }
  }
  
  mutating func U() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateU(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      Utils.shared.shuffled = Utils.shared.shuffled + "U"
      self.swap(empty:emptyIndex, index: emptyIndex - rowSize)
    }
  }
  
  mutating func D() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateD(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      Utils.shared.shuffled = Utils.shared.shuffled + "D"
      self.swap(empty:emptyIndex, index: emptyIndex + rowSize)
    }
  }
  
  func getEmptyIndex() -> Int {
    if let arr = self as? Array<Int> {
      for num in arr {
        if num == -1 {
          return arr.index(of: num)!
        }
      }
    }
    
    return -1
  }
  
  mutating func swap(empty:Int, index:Int) {
    let tmp = self[empty]
    self[empty] = self[index]
    self[index] = tmp
  }
}
