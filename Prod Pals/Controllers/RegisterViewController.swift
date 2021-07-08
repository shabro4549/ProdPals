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
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var profileImageField: UIImageView!
    @IBOutlet weak var passwordValidation: UILabel!
    @IBOutlet weak var emailValidation: UILabel!
    //    var startingSupporters: [String]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        
        emailTextField.layer.cornerRadius = 30
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 30
        passwordTextField.clipsToBounds = true
        registerButton.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_4))
        setupProfileImage()
        passwordValidation.text = ""
        emailValidation.text = ""

    }
    
    
    func setupProfileImage() {
        profileImageField.layer.masksToBounds = false
        profileImageField.layer.cornerRadius = profileImageField.frame.size.width / 2
        profileImageField.clipsToBounds = true
        profileImageField.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfilePickerView))
        profileImageField.addGestureRecognizer(tapGesture)
        profileImageField.isUserInteractionEnabled = true
    }
    
    @objc func handleProfilePickerView() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if password.count < 6 {
                    print("password must be at least 6 characters.")
                    self.passwordValidation.text = "password must be at least 6 characters."
                }
                
                let userRef = self.db.collection("users").document(email)
                userRef.getDocument(source: .cache) { (document, error) in
                    if ((document?.exists) != nil) {
                        print("User already exists")
                        self.emailValidation.text = "Email is already in use."
                    } else {
                        print("Email is free.")
                    }

                }

                 
                let imageName = UUID().uuidString
                
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                
                guard let uid = authResult?.user.uid else {
                    return
                }
        
                
                if let uploadData = self.profileImageField.image?.pngData() {
                    print(uploadData)
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        storageRef.downloadURL { (url, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            guard let profileUrl = url else { return }
                            self.createNewRegisteredUser(uid: uid, email: email, profileUrl: profileUrl.absoluteString, supporters: [])
                        }
//                        print("Your metadata is as follows \(metadata)")
                          
                    }
                }

                if let e = error {
                    print(e)
//                    let err = e as NSError
//                    switch err.code {
//                    case AuthErrorCode.emailAlreadyInUse.rawValue:
//                        print("Email already in use")
//                    case AuthErrorCode.invalidEmail.rawValue:
//                        print("Invalid email")
//                    default:
//                        print("Err unknown")
//                    }
                } else {
                    self.performSegue(withIdentifier: "RegisterToAccount", sender: self)
                }
                
            }
        }
    }
    
    private func createNewRegisteredUser(uid: String, email: String, profileUrl: String, supporters: [String]) {
        db.collection("users").document(email).setData([
            "uid": uid,
            "email": email,
            "profileURL": profileUrl,
            "supporting": [],
            "supporters": []
        ])
    }

    
    }



//MARK: - UIImagePickerController & UINavigationController Delegates

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageField.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)

    }
    

}
