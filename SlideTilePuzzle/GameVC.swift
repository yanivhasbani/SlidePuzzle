//
//  GameVC.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 8/11/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

class GameVC: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet var gameCollectionView: SwappingCollectionView!
  @IBOutlet var gameSize: UITextField!
  @IBOutlet var solveButton: UIButton!
  
  var board:Board?
  var solving:Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    gameSize.delegate = self
    gameSize.returnKeyType = UIReturnKeyType.done
    gameCollectionView.delegate = self
    gameCollectionView.dataSource = self
    gameCollectionView.swapDelegate = self
    
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    tapGR.delegate = self
    tapGR.numberOfTouchesRequired = 2
    gameCollectionView.addGestureRecognizer(tapGR)
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(_:)))
    gameCollectionView.addGestureRecognizer(longPressGesture)
    solving = false
  }
  
  func handleTap(_ gesture: UITapGestureRecognizer){
    gameSize.isHidden = false
    gameCollectionView.isHidden = true
    gameCollectionView.reloadData()
  }
  
  func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
    if (solving!) {
      return
    }
    switch(gesture.state) {
    case UIGestureRecognizerState.began:
      guard let selectedIndexPath = gameCollectionView.indexPathForItem(at: gesture.location(in: gameCollectionView)) else {
        break
      }
      if (board?.checkCellForMovement(at:selectedIndexPath))! {
        gameCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
      }
    case UIGestureRecognizerState.changed:
      gameCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
    case UIGestureRecognizerState.ended:
      gameCollectionView.endInteractiveMovement()
    default:
      gameCollectionView.cancelInteractiveMovement()
    }
  }
  
  
  
  @IBAction func solvePressed(_ sender: Any) {
    if !solving! {
      solving = true
      board?.solve()
      DispatchQueue.main.async {
        self.solveButton.titleLabel?.text = "Stop"
      }
    } else {
      solving = false
      board?.stop()
      DispatchQueue.main.async {
        self.solveButton.titleLabel?.text = "Solve"
      }
    }
  }
}


extension GameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let board =  board {
      return board.model.count
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideCell", for: indexPath) as? SlideCell,
      let board = board {
      cell.configureCell(number: String(board.model[indexPath.row]))
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
    if let sourceCell = collectionView.cellForItem(at: originalIndexPath) as? SlideCell,
      let destinationCell = collectionView.cellForItem(at: proposedIndexPath) as? SlideCell {
      if destinationCell.label.text != "",
        sourceCell.label.text != "" {
        return originalIndexPath
      }
      return proposedIndexPath
    }
    
    return originalIndexPath
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if let numOfElements = board?.rowSize {
      let width = (collectionView.frame.size.width) / CGFloat(numOfElements)
      let height = (collectionView.frame.size.height) / CGFloat(numOfElements)
      return CGSize(width:width, height:height)
    }
    return CGSize(width:0, height:0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension GameVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = gameSize.text, text.characters.count > 0,
      let size = Int(text) , size > 0{
      gameSize.resignFirstResponder()
      gameSize.isHidden = true
      gameCollectionView.isHidden = false
      board = Board.init(size:size)
      board?.delegate = self
      gameCollectionView.reloadData()
      return true
    }
    
    let alert = UIAlertController()
    alert.create(title: "Wrong board size",
                 message: "Please enter a number that has a integer square root")
    self.present(alert, animated: true, completion: nil)
    
    return false
  }
}

extension GameVC: SwapDelegate {
  func swapOccurred(at: IndexPath, with: IndexPath) {
    self.board?.swap(at: at, with: with)
  }
}

extension GameVC: BoardDelegate {
  func updateUI() {
    DispatchQueue.main.async {
      self.gameCollectionView.reloadData()
    }
  }
}
