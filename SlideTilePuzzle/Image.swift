//
//  Image.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 24/08/2017.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

extension UIImage {
  func image(withRotation radians: CGFloat) -> UIImage {
    let cgImage = self.cgImage!
    let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
    let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
    
    var drawRect = CGRect.zero
    drawRect.size = self.size
    let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
    drawRect.origin = drawOrigin
    var tf = CGAffineTransform.identity
    tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
    tf = tf.rotated(by: CGFloat(radians))
    tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
    context.concatenate(tf)
    context.draw(cgImage, in: drawRect)
    var rotatedImage = context.makeImage()!
    
    drawRect = drawRect.applying(tf)
    
    rotatedImage = rotatedImage.cropping(to: drawRect)!
    let resultImage = UIImage(cgImage: rotatedImage)
    return resultImage
    
    
  }
}

class Image {
  static let shared:Image = Image()
  var image:UIImage = UIImage(named:"Me")!
  var images:[UIImage] = []
  
  
  func shuffle(model:[Int], imageRef:UIImage) {
    image = imageRef
    images = self.slice(into: Int(sqrt(Double(model.count))))
  }
  
  func slice(into howMany: Int) -> [UIImage] {
    let width: CGFloat
    let height: CGFloat
    
    switch image.imageOrientation {
    case .left, .leftMirrored:
      image = image.image(withRotation: (CGFloat)(Double.pi/2  ))
      break
    case .right, .rightMirrored:
      image = image.image(withRotation: (CGFloat)(-Double.pi/2))
      break
    default:
      break
    }
    width = image.size.width
    height = image.size.height
    
    let tileWidth = Int(width / CGFloat(howMany))
    let tileHeight = Int(height / CGFloat(howMany))
    
    let scale = Int(image.scale)
    var images = [UIImage]()
    let cgImage = image.cgImage!
    
    var adjustedHeight = tileHeight
    
    var y = 0
    for row in 0 ..< howMany {
      if row == (howMany - 1) {
        adjustedHeight = Int(height) - y
      }
      var adjustedWidth = tileWidth
      var x = 0
      for column in 0 ..< howMany {
        if column == (howMany - 1) {
          adjustedWidth = Int(width) - x
        }
        let origin = CGPoint(x: x * scale, y: y * scale)
        let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
        let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
        images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
        x += tileWidth
      }
      y += tileHeight
    }
    return images
    
  }
}
