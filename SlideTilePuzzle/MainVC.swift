//
//  MainVC.swift
//  SlideTilePuzzle
//
//  Created by Yaniv Hasbani on 16/09/2017.
//  Copyright © 2017 Yaniv. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
  
  var uiType:Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func imagePressed(_ sender: Any) {
    uiType = 0;
    performSegue(withIdentifier: "GameVC", sender: self);
  }
  
  
  @IBAction func textPressed(_ sender: Any) {
    uiType = 1;
    
    performSegue(withIdentifier: "GameVC", sender: self);
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? GameVC,
      let senderVC = sender as? MainVC {
      vc.uiType = senderVC.uiType;
    }
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
