//
//  ViewController.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2020-10-09.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseButton: UIButton!
    @IBOutlet weak var goalTextField: UITextField!
    
    @IBAction func chooseButtonClicked(_ sender: UIButton) {
        print("Button Clicked")
    }
    
    @IBAction func goalButtonClicked(_ sender: Any) {
        print(goalTextField.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
    
    
}


