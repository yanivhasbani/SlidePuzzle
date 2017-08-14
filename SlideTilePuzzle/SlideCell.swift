//
//  SlideCell.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

class SlideCell: UICollectionViewCell {
  @IBOutlet var label: UILabel!
  
  func configureCell(number:String) {
    if number == "-1" {
      label.text = ""
    } else {
      label.text = String(number)
    }
  }
}
