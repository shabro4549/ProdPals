//
//  AddGoalViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-13.
//

import UIKit
import Firebase

class AddGoalViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var goalLabel: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var segmentLabel: UILabel!
    
    var selectedUsers: [String] = []
    var goalPassedBack: String  = ""
    var isShared: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.register(SelectedUserTableViewCell.nib(), forCellReuseIdentifier: SelectedUserTableViewCell.identifier)
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentLabel.text = "Public - goal + progress shared with supporters"
            addFriendsButton.alpha = 0
            friendsTableView.alpha = 0
        } else if segmentedControl.selectedSegmentIndex == 1 {
            segmentLabel.text = "Shared - goal + progress shared with chosen friends"
            addFriendsButton.alpha = 1
            friendsTableView.alpha = 1
        } else {
            segmentLabel.text = "Private - goal + progress is just for you"
            addFriendsButton.alpha = 0
            friendsTableView.alpha = 0
        }
        
        if isShared == true {
            segmentedControl.selectedSegmentIndex = 1
            addFriendsButton.alpha = 1
            friendsTableView.alpha = 1
        }

        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
        print("Selected Users in Goal ... \(selectedUsers)")
        print(segmentedControl.selectedSegmentIndex)
        print(isShared)
        goalLabel.text = goalPassedBack
    }
    
    @IBAction func addFriendsPressed(_ sender: Any) {
        
    }
    
    @IBAction func addGoalPressed(_ sender: Any) {
//        print("Goal to save ... \(goalLabel.text!)")
//        print("Segment number ... \(segmentedControl.selectedSegmentIndex)")
//        print("Users to save ... \(selectedUsers)")
        
        var selectedSegment = ""
        if segmentedControl.selectedSegmentIndex == 0 {
           selectedSegment = "public"
        } else if  segmentedControl.selectedSegmentIndex == 1 {
            selectedSegment = "shared"
        } else {
            selectedSegment = "private"
        }
        
        if let addedGoal = goalLabel.text, let user = Auth.auth().currentUser?.email {
            selectedUsers.append(user)
            print("Users to save ... \(selectedUsers)")
            let date = Date()
            let sortingDate = date.timeIntervalSince1970
            
            self.db.collection("bigGoals").addDocument(data: [
                "bigGoal" : addedGoal,
                "user" : user,
                "type" : selectedSegment,
                "users" : selectedUsers
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving new goal data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }
            
            self.db.collection("chats").document("\(selectedUsers)+\(addedGoal)").collection("messages").addDocument(data: [
                "date" : sortingDate,
                "sender" : user,
                "content" : "Hi, I have added you to my goal, \(addedGoal)"
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving new chat data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }

        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentLabel.text = "Public - goal + progress shared with supporters"
            addFriendsButton.alpha = 0
            friendsTableView.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            segmentLabel.text = "Shared - goal + progress shared with chosen friends"
            addFriendsButton.alpha = 1
            friendsTableView.alpha = 1
        } else {
            segmentLabel.text = "Private - goal + progress is just for you"
            addFriendsButton.alpha = 0
            friendsTableView.alpha = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearch" {
            let destinationVC = segue.destination as! GoalSearchViewController
            destinationVC.currentSelected = selectedUsers
            destinationVC.goalEntered = goalLabel.text!
    
            print("In prepare ... \(selectedUsers)")
        }
        }

}

//MARK: -  UITableView Delegate and DataSource

extension AddGoalViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = friendsTableView.dequeueReusableCell(withIdentifier: "SelectedUserTableViewCell", for: indexPath) as! SelectedUserTableViewCell
        cell.configure(with: selectedUsers[indexPath.row])
        return cell
    }
    
    
}
