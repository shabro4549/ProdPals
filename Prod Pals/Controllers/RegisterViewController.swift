//
//  RegisterViewController.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2020-10-27.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "RegisterToAccount", sender: self)
                }
            }
            
        }
        

        print(emailTextField.text!)
        print(passwordTextField.text!)
    }
    
    }
