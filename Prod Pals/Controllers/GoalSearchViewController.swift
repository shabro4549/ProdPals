//
//  GoalSearchViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-15.
//

import UIKit
import Firebase

class GoalSearchViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var users: [User] = []
    var filteredUsers: [User] = []
    var currentSelected: [String] = []
    var selectedUser: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Current selected = \(currentSelected)")
        
        searchTableView.register(GoalSearchTableViewCell.nib(), forCellReuseIdentifier: GoalSearchTableViewCell.identifier)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        
        loadUsers()
    }
    
    func loadUsers() {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("Error loading users from firebase. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()

                        if let emailData = data["email"] as? String, let imageData = data["profileURL"] as? String {
                            let newUser = User(uid: "", email: emailData, profileURL: imageData, supporters: [])
                            self.users.append(newUser)
                        }

                    }
                }
            }
        }
    }

}

//MARK: - searchTableView Delegate & DataSource Methods

extension GoalSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "GoalSearchTableViewCell", for: indexPath) as! GoalSearchTableViewCell
        print("Users in cellForRowAt ... \(users)")
        cell.delegate = self
        cell.configure(with: filteredUsers[indexPath.row].email, with: filteredUsers[indexPath.row].profileURL)
        return cell
    }

}

//MARK: - GoalSearchTableViewCell Delegate

extension GoalSearchViewController : GoalSearchTableViewCellDelegate {
    func didTapButton(with title: String) {
        selectedUser = title
        print("Selected user = \(selectedUser)")
//        navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "backToGoal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddGoalViewController
        currentSelected.append(selectedUser)
        destinationVC.selectedUsers = currentSelected
        destinationVC.isShared = true
    }
}

//MARK: - UISearchBar Delegate

extension GoalSearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text!)
        filteredUsers = users.filter { $0.email.contains(searchBar.text!) }
        print(filteredUsers)
        
        searchTableView.reloadData()
        print(users)
    }
}

