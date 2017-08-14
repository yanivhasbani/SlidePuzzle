//
//  UIAlertController+MyAlert.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

extension UIAlertController {
  func create(title:String, message:String) {
    self.title = title
    self.message = message
    
    self.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil))
  }
}
