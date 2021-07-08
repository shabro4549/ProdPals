//
//  WelcomeViewController.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2020-10-27.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.layer.cornerRadius = 30
        registerBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 30
        loginBtn.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
}
