//
//  SearchViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-09.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users: [User] = []
    var filteredUsers: [User] = []
    var selectedUser: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.register(SearchTableViewCell.nib(), forCellReuseIdentifier: SearchTableViewCell.identifier)
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

//MARK: - UITableView Delegate and DataSource

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        print("Users in cellForRowAt ... \(users)")
        cell.delegate = self
        cell.configure(with: filteredUsers[indexPath.row].email, with: filteredUsers[indexPath.row].profileURL)
        return cell
    }
    
}

//MARK: - SearchTableViewCell Delegate

extension SearchViewController : SearchTableViewCellDelegate {
    func didTapButton(with title: String) {
        selectedUser = title
        performSegue(withIdentifier: "goToAccount", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SearchedUserViewController
        destinationVC.searchedUser = selectedUser
    }
}


//MARK: - UISearchBar Delegate

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text!)
        filteredUsers = users.filter { $0.email.contains(searchBar.text!) }
        print(filteredUsers)
        
        searchTableView.reloadData()
        print(users)
    }
}

