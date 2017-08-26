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
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var selectedView: UIView!
  
  func configureCell(number:String) {
    if number == "-1" {
      label.text = ""
      image.image = nil
    } else {
      label.text = String(number)
      if let num = Int(number) {
          let x = Image.shared.images
          image.image = x[num-1]
      }
    }
  }
  
  func selectCell() {
    selectedView.isHidden = false
  }
  
  func deselectCell() {
    selectedView.isHidden = true
  }
}
