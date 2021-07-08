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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIImageView!
    let db = Firestore.firestore()
    var goalColours = [#colorLiteral(red: 1, green: 0.6235294118, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.7921568627, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 1, green: 0.4196078431, blue: 0.4196078431, alpha: 1), #colorLiteral(red: 0.2823529412, green: 0.8588235294, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.1137254902, green: 0.8196078431, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0, green: 0.8235294118, blue: 0.8274509804, alpha: 1), #colorLiteral(red: 0.3294117647, green: 0.6274509804, blue: 1, alpha: 1), #colorLiteral(red: 0.3725490196, green: 0.1529411765, blue: 0.8039215686, alpha: 1)]
    var bigGoals: [Goal] = []
    var usersGoal: [String] = []
    var user = Auth.auth().currentUser
    var image: UIImage? = nil
    var selectedGoalTitle = ""
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var goalButton: UIButton!
    @IBOutlet weak var supportingCount: UILabel!
    @IBOutlet weak var supporterCount: UILabel!
    let customAlert = GoalAlert()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPicture()
        countSupporting()
        countSupporters()
    

        navigationItem.hidesBackButton = true
        
        tableView.register(GoalTableViewCell.nib(), forCellReuseIdentifier: GoalTableViewCell.identifier)
        loadGoals()
        tableView.delegate = self
        tableView.dataSource = self
        displayName.text = user?.email!
        goalButton.layer.cornerRadius = 10
        goalButton.clipsToBounds = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchTapped(tapGestureRecognizer:)))
            searchButton.isUserInteractionEnabled = true
            searchButton.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func countSupporting() {
        if let userEmail = user?.email {
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
    
    func countSupporters() {
        if let userEmail = user?.email {
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

    
    @objc func searchTapped(tapGestureRecognizer: UITapGestureRecognizer) {
                
        searchButton.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: {
            self.searchButton.alpha = 1
        })
        
        let userSearched = searchField.text!
                
        let docRef = db.collection("users").whereField("email", isEqualTo: userSearched)

        docRef.getDocuments {
            (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        if (querySnapshot!.documents.isEmpty) {
                            print("no users found")
                            self.searchField.text = ""
                            let redPlaceholderText = NSAttributedString(string: "User Not Found.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                            self.searchField.attributedPlaceholder = redPlaceholderText
                        } else {
                            print("user found")
                            self.performSegue(withIdentifier: "goToUser", sender: self)
                        }
                }
        }

    }
    
    @IBAction func goalButtonClicked(_ sender: UIButton) {
        
        customAlert.showAlert(with: "Add a New Goal", message: "Keep your goal public, within a group, or private", on: self)

        func dismissAlert() {
            customAlert.dismissAlert()
        }
        
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Add a Big Goal", message: "A goal with sub goals", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Add Goal", style: .default) { (action) in
//
//        if let addedGoal = textField.text, let user = Auth.auth().currentUser?.email {
//            self.db.collection("bigGoals").addDocument(data: [
//                    "bigGoal" : addedGoal,
//                    "user" : user
//            ]) { (error) in
//                    if let e = error {
//                        print("There was an issue saving data to firestore, \(e)")
//                    } else {
//                        print("Successfully saved data.")
//                    }
//                }
//            }
//
//            self.tableView.reloadData()
//            self.usersGoal = []
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Type your big goal here..."
//            textField = alertTextField
//        }
//
//        alert.addAction(action)
//
//        present(alert, animated: true, completion: nil)
        
    }
    
    func loadGoals() {

        db.collection("bigGoals").addSnapshotListener { (querySnapshot, error) in

            self.bigGoals = []

            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
//                        print("This is the doc in snapshotListener for bigGoals ... \(doc.data())")
                        let data = doc.data()
                        
                        if let userData = data["user"] as? String, let goalData = data["bigGoal"] as? String {
                            let newGoal = Goal(user: userData, goal: goalData)
                            
                            self.bigGoals.append(newGoal)

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }

    }
    
    
    func setupPicture(){
//        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        imageView.addGestureRecognizer(tapGesture)
        
        db.collection("users").addSnapshotListener { [self] (querySnapshot, error) in

            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
//                        print("This is the doc data from users snapshotListener ... \(doc.data())")
                        let data = doc.data()
                        let userEmail = self.user?.email
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
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
        usersGoal = []
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
//        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
    
    
}

//MARK: - UITableView DataSource & Delegate Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counter = 0
        for goal in bigGoals {
            if goal.user == Auth.auth().currentUser?.email {
                counter = counter + 1
            }
        }
        return counter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalTableViewCell.identifier, for: indexPath) as! GoalTableViewCell
        cell.delegate = self
        
        for goal in bigGoals {
            if goal.user == Auth.auth().currentUser?.email {
                usersGoal.append(goal.goal)
            }
        }
        
        cell.configure(with: usersGoal[indexPath.row])
        print("Row at Index Path ... \(indexPath.row)")
        print(usersGoal)
        usersGoal = []
        cell.bigGoalButton.backgroundColor = goalColours.randomElement()
        cell.bigGoalButton.layer.cornerRadius = 20
        cell.bigGoalButton.layer.masksToBounds = true
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! ProgressViewController
//        destinationVC.viewDidLoad()
//    }
    

}


//MARK: - GoalTableViewCell Delegate

extension ViewController: GoalTableViewCellDelegate {
    func didTapButton(with title: String) {
        selectedGoalTitle = title
        performSegue(withIdentifier: "goToGoalProgress", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGoalProgress" {
            let destinationVC = segue.destination as! ProgressViewController
            destinationVC.selectedGoal = selectedGoalTitle
            print(selectedGoalTitle)
        }
        
        if segue.identifier == "goToUser" {
            let destinationVC = segue.destination as! SearchedUserViewController
            destinationVC.searchedUser = searchField.text!
//            destinationVC.authedUser = user
//            print(searchField.text!)
        }
        
    }
    
}




//MARK: - UIImagePickerController Delegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            imageView.image = imageSelected
            
            guard let imageSelected = self.image else {
                print("Avatar is nil")
                return
            }
            
            guard imageSelected.jpegData(compressionQuality: 0.4) != nil else {
                return
            }


        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            imageView.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - GoalAlert

class GoalAlert: UIViewController {
    
    let sampleTextField =  UITextField(frame: CGRect(x: 45, y: 100, width: 240, height: 42))
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
        static let toggleAlphaTo: CGFloat = 1
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var myTargetView: UIView?
    
    func showAlert(with title: String, message: String, on viewController: UIViewController) {

        guard let targetView = viewController.view else {
            return
        }
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-80, height: 350)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Baloo", size: 22)
        alertView.addSubview(titleLabel)
        
       
            sampleTextField.placeholder = "Name of goal"
            sampleTextField.font = UIFont.systemFont(ofSize: 15)
            sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
            sampleTextField.autocorrectionType = UITextAutocorrectionType.no
            sampleTextField.keyboardType = UIKeyboardType.default
            sampleTextField.returnKeyType = UIReturnKeyType.done
            sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
            sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//            sampleTextField.delegate = self
            alertView.addSubview(sampleTextField)
        
        let items: [UIImage] = [
            UIImage(systemName: "globe")!,
            UIImage(systemName: "person.2.fill")!,
            UIImage(systemName: "lock.fill")!
        ]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 45, y: 180,
                                width: 240, height: 42)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        customSC.selectedSegmentTintColor = #colorLiteral(red: 0.1137254902, green: 0.8196078431, blue: 0.631372549, alpha: 1)
        alertView.addSubview(customSC)
        
        let messageLabel = UILabel(frame: CGRect(x: 45, y: 160, width: alertView.frame.size.width, height: 170))
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.font = messageLabel.font.withSize(10)
        messageLabel.textAlignment = .left
        alertView.addSubview(messageLabel)
        
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.height-50, width: alertView.frame.size.width, height: 50))
        button.setTitle("Add Goal", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), for: .normal)
        button.titleLabel?.font =  UIFont(name: "Baloo", size: 16)
        button.backgroundColor = #colorLiteral(red: 0.1188176796, green: 0.1861543655, blue: 0.2486641407, alpha: 1)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        
        
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                })
            }
            
        })
        
        
    }
    
    @objc func dismissAlert() {
        print(sampleTextField.text!)
        
//                if let addedGoal = sampleTextField.text, let user = Auth.auth().currentUser?.email {
//                    self.db.collection("bigGoals").addDocument(data: [
//                            "bigGoal" : addedGoal,
//                            "user" : user
//                    ]) { (error) in
//                            if let e = error {
//                                print("There was an issue saving data to firestore, \(e)")
//                            } else {
//                                print("Successfully saved data.")
//                            }
//                        }
//                    }
        
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width-80, height: 300)
            
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }, completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }
            
        })
    }
    
    
}

//MARK: - alertTextField Delegate

//extension GoalAlert: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//         // return NO to disallow editing.
//         print("TextField should begin editing method called")
//         return true
//     }
//
//     func textFieldDidBeginEditing(_ textField: UITextField) {
//         // became first responder
//         print("TextField did begin editing method called")
//     }
//
//     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//         // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//         print("TextField should snd editing method called")
//         return true
//     }
//
//     func textFieldDidEndEditing(_ textField: UITextField) {
//         // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//         print("TextField did end editing method called")
//     }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//         // if implemented, called in place of textFieldDidEndEditing:
//         print("TextField did end editing with reason method called")
//
//     }
//
//     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//         // return NO to not change text
//         print("While entering the characters this method gets called")
//         return true
//     }
//
//     func textFieldShouldClear(_ textField: UITextField) -> Bool {
//         // called when clear button pressed. return NO to ignore (no notifications)
//         print("TextField should clear method called")
//         return true
//     }
//
//     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//         // called when 'return' key pressed. return NO to ignore.
//         print("TextField should return method called")
//         // may be useful: textField.resignFirstResponder()
//         return true
//     }
//
//
//}

