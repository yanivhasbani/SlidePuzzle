import UIKit

extension UIView {
  func snapshot() -> UIImage {
    UIGraphicsBeginImageContext(self.bounds.size)
    self.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}

extension CGPoint {
  func distanceToPoint(p:CGPoint) -> CGFloat {
    return sqrt(pow((p.x - x), 2) + pow((p.y - y), 2))
  }
}

struct SwapDescription : Hashable {
  var firstItem : Int
  var secondItem : Int
  
  var hashValue: Int {
    get {
      return (firstItem * 10) + secondItem
    }
  }
}

func ==(lhs: SwapDescription, rhs: SwapDescription) -> Bool {
  return lhs.firstItem == rhs.firstItem && lhs.secondItem == rhs.secondItem
}

protocol SwapDelegate {
  func swapOccurred(at:IndexPath, with:IndexPath)
}

class SwappingCollectionView: UICollectionView {
  
  var interactiveIndexPath : NSIndexPath?
  var interactiveView : UIView?
  var interactiveCell : SlideCell?
  var swapSet : Set<SwapDescription> = Set()
  var previousPoint : CGPoint?
  var swapDelegate:SwapDelegate?
  
  static let distanceDelta:CGFloat = 2 // adjust as needed
  
  override func beginInteractiveMovementForItem(at indexPath: IndexPath) -> Bool {
    
    self.interactiveIndexPath = indexPath as NSIndexPath
    
    self.interactiveCell = self.cellForItem(at: indexPath) as? SlideCell
    self.interactiveCell?.selectCell()
    
    self.interactiveView = UIImageView(image: self.interactiveCell?.snapshot())
    self.interactiveView?.frame = self.interactiveCell!.frame
    
    self.addSubview(self.interactiveView!)
    self.bringSubview(toFront: self.interactiveView!)
    
    self.interactiveCell?.isHidden = true
    
    return true
  }
  
  override func updateInteractiveMovementTargetPosition(_ targetPosition: CGPoint) {
    
    if (self.shouldSwap(newPoint: targetPosition)) {
      
      if let hoverIndexPath = self.indexPathForItem(at: targetPosition), let interactiveIndexPath = self.interactiveIndexPath {
        
        if let changingCell = self.cellForItem(at: interactiveIndexPath as IndexPath) as? SlideCell,
          let text = changingCell.label.text,
          let hoverCell = self.cellForItem(at: hoverIndexPath as IndexPath) as? SlideCell,
          let hoverText = hoverCell.label.text {
          if hoverText != "", text != "" {
            self.interactiveView?.center = targetPosition
            self.previousPoint = targetPosition
            return
          }
        }
        
        let swapDescription = SwapDescription(firstItem: interactiveIndexPath.item, secondItem: hoverIndexPath.item)
        
        if (!self.swapSet.contains(swapDescription)) {
          
          self.swapSet.insert(swapDescription)
          
          self.performBatchUpdates({
            self.moveItem(at: interactiveIndexPath as IndexPath, to: hoverIndexPath)
            self.moveItem(at: hoverIndexPath, to: interactiveIndexPath as IndexPath)
            if let delegate = self.swapDelegate {
              delegate.swapOccurred(at: interactiveIndexPath as IndexPath, with: hoverIndexPath)
            }
          }, completion: {(finished) in
            self.swapSet.remove(swapDescription)
            self.dataSource?.collectionView!(self, moveItemAt: interactiveIndexPath as IndexPath, to: hoverIndexPath)
            self.interactiveIndexPath = hoverIndexPath as NSIndexPath
            
          })
        }
      }
    }
    
    self.interactiveView?.center = targetPosition
    self.previousPoint = targetPosition
  }
  
  override func endInteractiveMovement() {
    self.cleanup()
  }
  
  override func cancelInteractiveMovement() {
    self.cleanup()
  }
  
  func cleanup() {
    self.interactiveCell?.isHidden = false
    self.interactiveView?.removeFromSuperview()
    self.interactiveView = nil
    self.interactiveCell?.deselectCell()
    self.interactiveCell = nil
    self.interactiveIndexPath = nil
    self.previousPoint = nil
    self.swapSet.removeAll()
  }
  
  func shouldSwap(newPoint: CGPoint) -> Bool {
    if let previousPoint = self.previousPoint {
      let distance = previousPoint.distanceToPoint(p: newPoint)
      return distance < SwappingCollectionView.distanceDelta
    }
    
    return false
  }
}
