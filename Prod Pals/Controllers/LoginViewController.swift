//
//  LoginViewController.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2020-10-27.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LoginToAccount", sender: self)
                }
              }
        }
        
    }
    
    override func viewDidLoad() {
        emailTextField.layer.cornerRadius = 30
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 30
        passwordTextField.clipsToBounds = true
        loginButton.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_4))
    }
    
}
