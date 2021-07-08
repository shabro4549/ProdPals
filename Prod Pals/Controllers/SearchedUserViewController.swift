//
//  SearchedUserViewController.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2021-03-23.
//

import Foundation
import UIKit
import Firebase

class SearchedUserViewController: UIViewController {
    
    var authedUser = Auth.auth().currentUser
    var searchedUser: String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    let db = Firestore.firestore()
    @IBOutlet weak var supportingCount: UILabel!
    @IBOutlet weak var supporterCount: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(searchedUser!)
        userTitle.text = searchedUser!
        setupPicture()
        setButtonTitle()
        countSupporters()
        countSupporting()
        searchButton.layer.cornerRadius = 18
        searchButton.clipsToBounds = true
    }
    
    func setButtonTitle() {
        
        if let userName = authedUser?.email {
            let userRef = db.collection("users").document(userName)
            let newSupporting = "\(searchedUser!)"
            userRef.getDocument(source: .cache) { (document, error) in
              if let document = document {
                if let property = document.get("supporting") {
                    if let supportingArray = property as! NSArray as? [String] {
                        print("These are the peeps you're supporting: \(supportingArray)")
//                        let localArray = supportingArray
//                        print("This is the local array... \(localArray)")
//                        print("This is the user to take out... \(searchValue)")
                        
                        var currentIndex = 0
                        
                        for supporting in supportingArray {
                            if supporting == newSupporting {
                                currentIndex += 1
                            }
                        }
                        
                        print(currentIndex)
                        if currentIndex == 0 {
                            self.searchButton.setTitle("Support", for: .normal)
                        } else {
                            self.searchButton.setTitle("Supporting", for: .normal)
                        }
                        
                    }
                }
              } else {
                print("Document does not exist in cache")
              }
            }
        }
        
        
//        if let userEmail = authedUser?.email {
//            let userRef = db.collection("users").document(userEmail).addSnapshotListener { (querySnapshot, error) in
//
//                if let e = error {
//                    print("There was an issue retrieving data from Firestore. \(e)")
//                } else {
//
//                    let userRef = self.db.collection("users").document(userEmail)
//                    userRef.getDocument(source: .cache) { (document, error) in
//                      if let document = document {
//                        if let property = document.get("supporting") {
//                            if let supportingArray = property as! NSArray as? [String] {
////                                print("These are the people you're supporting: \(supportingArray)")
//                                let searchValue = self.searchedUser!
//                                var index = 0
//
//                                for supporting in supportingArray {
//                                    if supporting == searchValue {
//                                        break
//                                    }
//
//                                    index += 1
//                                }
//
//                                if index == 0 {
//                                    self.searchButton.setTitle("Support", for: .normal)
//                                } else {
//                                    self.searchButton.setTitle("Supporting", for: .normal)
//                                }
//
//                            }
//                        }
//                      } else {
//                        print("Document does not exist in cache")
//                      }
//                    }
//                }
//            }
//        }
//
    }
    
    func countSupporters() {
        if let userEmail = searchedUser {
            db.collection("users").document(userEmail).addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    let userRef = self.db.collection("users").document(userEmail)
                    userRef.getDocument(source: .cache) { (document, error) in
                      if let document = document {
                        if let property = document.get("supporters") {
                            if let supportersArray = property as! NSArray as? [String] {
                                print("These are the people you're supporting: \(supportersArray)")
                                let numberOfSupporters = supportersArray.count
                                print("You are supporting \(numberOfSupporters) people")
                                
                                self.supporterCount.text = String(numberOfSupporters)
                            }
                        }
                      } else {
                        print("Document does not exist in cache")
                      }
                    }
                }
            }
        }
        
    }
    
    func countSupporting() {
        if let userEmail = searchedUser {
            db.collection("users").document(userEmail).addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    let userRef = self.db.collection("users").document(userEmail)
                    userRef.getDocument(source: .cache) { (document, error) in
                      if let document = document {
                        if let property = document.get("supporting") {
                            if let supportingArray = property as! NSArray as? [String] {
                                print("These are the people you're supporting: \(supportingArray)")
                                let numberOfSupporting = supportingArray.count
                                print("You are supporting \(numberOfSupporting) people")
                                
                                self.supportingCount.text = String(numberOfSupporting)
                            }
                        }
                      } else {
                        print("Document does not exist in cache")
                      }
                    }
                }
            }
        }
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        if searchButton.currentTitle == "Support" {
            if let userName = authedUser?.email {
                let userRef = db.collection("users").document(userName)
                let newSupporting = "\(searchedUser!)"
                userRef.getDocument(source: .cache) { (document, error) in
                  if let document = document {
                    if let property = document.get("supporting") {
                        if let supportingArray = property as! NSArray as? [String] {
                            print("These are the peeps you're supporting: \(supportingArray)")
                            var localArray = supportingArray
                            localArray.append(newSupporting)
                            userRef.updateData([
                                "supporting" : localArray
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated!")
                                }
                            }
                            
                        }
                    }
                  } else {
                    print("Document does not exist in cache")
                  }
                }
            }
            
            if let supportingUserName = searchedUser {
                let supportingUserRef = db.collection("users").document(supportingUserName)
                
                if let newSupporter = authedUser?.email {
                    supportingUserRef.getDocument(source: .cache) { (document, error) in
                      if let document = document {
                        if let property = document.get("supporters") {
                            if let supportersArray = property as! NSArray as? [String] {
                                print("These are the supporters for the searched user: \(supportersArray)")
                                var localArray = supportersArray
                                localArray.append("\(newSupporter)")
                                supportingUserRef.updateData([
                                    "supporters" : localArray
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated!")
                                    }
                                }
                                
                            }
                        }
                      } else {
                        print("Document does not exist in cache")
                      }
                    }
                    
                }

            }
            
            searchButton.setTitle("Supporting", for: .normal)
        } else if searchButton.currentTitle == "Supporting" {
            print("You have stopped supporting this user.")
            
            if let userName = authedUser?.email {
                let userRef = db.collection("users").document(userName)
                let newSupporting = "\(searchedUser!)"
                userRef.getDocument(source: .cache) { (document, error) in
                  if let document = document {
                    if let property = document.get("supporting") {
                        if let supportingArray = property as! NSArray as? [String] {
                            print("These are the peeps you're supporting: \(supportingArray)")
                            let localArray = supportingArray.filter { $0 != newSupporting }
                            userRef.updateData([
                                "supporting" : localArray
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated!")
                                }
                            }
                            
                        }
                    }
                  } else {
                    print("Document does not exist in cache")
                  }
                }
            }
            
            if let supportingUserName = searchedUser {
                let supportingUserRef = db.collection("users").document(supportingUserName)
                
                if let newSupporter = authedUser?.email {
                    supportingUserRef.getDocument(source: .cache) { (document, error) in
                      if let document = document {
                        if let property = document.get("supporters") {
                            if let supportersArray = property as! NSArray as? [String] {
                                print("These are the supporters for the searched user: \(supportersArray)")
                                let localArray = supportersArray.filter { $0 != "\(newSupporter)" }
                                supportingUserRef.updateData([
                                    "supporters" : localArray
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated!")
                                    }
                                }
                                
                            }
                        }
                      } else {
                        print("Document does not exist in cache")
                      }
                    }
                    
                }

            }
            searchButton.setTitle("Support", for: .normal)
        } else {
            print("searchButton error, title is an unaccounted for option.")
        }
    
    }
        
    
    
    func setupPicture(){
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
//        imageView.isUserInteractionEnabled = true
        
        db.collection("users").addSnapshotListener { [self] (querySnapshot, error) in

            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
//                        print("This is the doc data from users snapshotListener ... \(doc.data())")
                        let data = doc.data()
                        
                        let userEmail = searchedUser!
                        if let emailData = data["email"] {
                            let emailDataString = emailData as! String

                            if emailDataString == userEmail {
                                
                                let userProfileUrl = data["profileURL"] as! String
                                let url = URL(string: userProfileUrl)!
                                print("This is the link for this users profile image... \(userProfileUrl)")

                                URLSession.shared.dataTask(with: url) { (data, response, error) in

                                    if let data = data {
                                        
                                        DispatchQueue.main.async() { [weak self] in
                                                    self?.imageView.image = UIImage(data: data)
                                                }

                                    } else {
                                        print(error!)
                                    }
                                }.resume()
                            
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    
    
}
