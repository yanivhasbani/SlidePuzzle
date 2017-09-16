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
  @IBOutlet weak var stack: UIStackView!
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var progress: UIActivityIndicatorView!
  
  var uiType:Int = 0
  var board:Board?
  var solving:Bool?
  var imageLoaded:Bool = false
  var imagePicker = UIImagePickerController()
  var imageRef:UIImage?
  
  override func viewDidLoad() {
    if uiType == 1 {
      imageButton.isHidden = true
    }
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    gameSize.delegate = self
    gameSize.returnKeyType = UIReturnKeyType.done
    gameCollectionView.delegate = self
    gameCollectionView.dataSource = self
    gameCollectionView.swapDelegate = self
    
    progress.isHidden = true
    
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    tapGR.delegate = self
    tapGR.numberOfTouchesRequired = 2
    gameCollectionView.addGestureRecognizer(tapGR)
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(_:)))
    gameCollectionView.addGestureRecognizer(longPressGesture)
    
    let imagePress = UITapGestureRecognizer(target: self, action: #selector(self.imageViewPressed(_:)))
    imageView.addGestureRecognizer(imagePress)
    imageView.isUserInteractionEnabled = true
    solving = false
  }
  
  func handleTap(_ gesture: UITapGestureRecognizer){
    progress.isHidden = true
    stack.isHidden = false
    gameCollectionView.isHidden = true
    board?.dismiss()
    board = nil
//    gameCollectionView.reloadData()
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
  
  func imageViewPressed(_ gesture: UITapGestureRecognizer) {
    loadPicker()
  }
  
  @IBAction func imagePressed(_ sender: Any) {
    loadPicker()
  }
  
  func loadPicker() {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
      imagePicker.delegate = self
      imagePicker.sourceType = .savedPhotosAlbum;
      imagePicker.allowsEditing = false
      
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  @IBAction func solvePressed(_ sender: Any) {
    if !solving! {
      solving = true
      board?.getSolution()
      DispatchQueue.main.async {
        self.solveButton.setTitle("Stop", for: UIControlState.normal)
      }
    } else {
      solving = false
      board?.stop()
      DispatchQueue.main.async {
        self.solveButton.setTitle("Solve", for: UIControlState.normal)
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
      return board.currentlyShowing.model.count
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideCell", for: indexPath) as? SlideCell,
      let board = board {
      cell.configureCell(number: String(board.currentlyShowing.model[indexPath.row]))
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
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == (board?.model.model.count)! - 1 {
      progress.stopAnimating()
      let time = DispatchTime.now() + 1
      DispatchQueue.global().asyncAfter(deadline: time, execute: {
        self.board?.displayNextStep()
      })
    }
  }
}

extension GameVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = gameSize.text, text.characters.count > 0,
      let size = Int(text) , (uiType == 1 && size > 1) || (uiType == 0 && size > 1 && size < 6) {
      if uiType == 0, !imageLoaded {
        gameSize.resignFirstResponder()
        let alert = UIAlertController()
        alert.create(title: "No Image",
                     message: "Please load an image..")
        self.present(alert, animated: true, completion: nil)
        return false
      }
      gameSize.resignFirstResponder()
      progress.isHidden = false
      stack.isHidden = true
      progress.startAnimating()
      DispatchQueue.main.async {
        self.board = Board.init(size:size, image:self.imageRef)
        self.gameCollectionView.isHidden = false
        self.board?.delegate = self
        self.gameCollectionView.reloadData()
        self.solveButton.isHidden = false
        self.solveButton.setTitle("Solve", for: UIControlState.normal)
        self.board!.trySolving()
      }
      return true
    }
    
    if uiType == 0 {
      let alert = UIAlertController()
      alert.create(title: "Wrong board size",
                   message: "Please enter a number that is between 1 and 6")
      self.present(alert, animated: true, completion: nil)
    } else {
      let alert = UIAlertController()
      alert.create(title: "Wrong board size",
                   message: "Please enter a number that is bigger than 1")
      self.present(alert, animated: true, completion: nil)
    }
    
    
    return false
  }
}

extension GameVC: SwapDelegate {
  func swapOccurred(at: IndexPath, with: IndexPath) {
    self.board?.swap(at: at, with: with)
    board?.solution = (result:false, path:[])
  }
}

extension GameVC: BoardDelegate {
  func updateCollection() {
    DispatchQueue.main.async {
      self.gameCollectionView.reloadData()
    }
  }
  
  func updateLabel() {
    DispatchQueue.main.async {
      self.solving = false
      DispatchQueue.main.async {
        self.solveButton.isHidden = true
      }
    }
  }
}

extension GameVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil);
    DispatchQueue.main.async {
      if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        self.imageRef = image
        self.imageLoaded = true
        self.imageButton.isHidden = true
        self.imageView.image = image
        self.imageView.isHidden = false
        self.textFieldShouldReturn(self.gameSize)
      }
    }
  }
}
