//
//  Array+BoardMoves.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/13/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

extension Array {
  func rateMove(move:BoardMove, solved:[Int]) -> (rate:Int, board:[Int]) {
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
    
    return (rate:self.rate(arr:arr, solved: solved), board:arr)
  }
  
  private func rate(arr:[Int], solved:[Int]) -> Int {
    if let beforeChanged = self as? Array<Int>,
      arr != beforeChanged {
      var rate = 0
      for num in arr {
        if arr[arr.index(of: num)!] != solved[arr.index(of: num)!] {
          rate = rate + 1
        }
      }
      var beforeRate = 0
      for num in beforeChanged {
        if beforeChanged[beforeChanged.index(of: num)!] != solved[beforeChanged.index(of: num)!] {
          beforeRate = beforeRate + 1
        }
      }
      if beforeRate < rate {
        print("not improving..")
      }
      
      return rate
    }
    
    return Int.max
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
      self.swap(empty:emptyIndex, index: emptyIndex + 1)
    }
  }
  
  mutating func L() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateL(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      self.swap(empty:emptyIndex, index: emptyIndex - 1)
    }
  }
  
  mutating func U() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateU(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
      self.swap(empty:emptyIndex, index: emptyIndex - rowSize)
    }
  }
  
  mutating func D() {
    let rowSize = Int(sqrt(Double(self.count)))
    let emptyIndex = self.getEmptyIndex()
    if validateD(emptyIndex: emptyIndex, rowSize: rowSize) {
      print("valid \(#function)")
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
