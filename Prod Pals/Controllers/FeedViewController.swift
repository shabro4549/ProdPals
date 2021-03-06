//
//  FeedViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-08.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    var usersSupporters : [String] = []
    var progressItems: [Progress] = []
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.identifier)
        feedTableView.delegate = self
        feedTableView.dataSource = self
        getSupporters()
        loadFeed()
        // Do any additional setup after loading the view.
    }
    
    func getSupporters() {
        if let userEmail = user?.email {
            db.collection("users").whereField("email", isEqualTo: userEmail).addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore when loading feed for FeedViewController. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let supportingData = data["supporting"] as? Array<String> {
                                print("FeedViewController ... \(supportingData)")
                                self.usersSupporters = supportingData
                                
                                DispatchQueue.main.async {
                                    self.feedTableView.reloadData()

                                }
                            }
                        }

                    }
                }
            }
        }
    }
    
    func loadFeed() {
        print("LoadFeed current supporters ... \(usersSupporters)")
        db.collection("goalProgress").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore when loading feed for FeedViewController. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {

                    for doc in snapshotDocuments {
                        
                        let data = doc.data()
                        
                        if let dateData = data["date"] as? String, let goalData = data["goal"] as? String, let imageData = data["images"] as? String, let userData = data["user"] as? String {
                            
                            print("userSupporters in loadFeed ... \(self.usersSupporters)")
                            
                            for user in self.usersSupporters {
                                if user == userData {
                                    self.progressItems.append(Progress(date: dateData, goal: goalData, image: imageData, user: userData))
                                }
                            }
        
//                            self.progressItems.append(Progress(date: dateData, goal: goalData, image: imageData, user: userData))
                            
                            DispatchQueue.main.async {
                                self.feedTableView.reloadData()

                            }
                        }
                    }
                    print("Progress Items ... \(self.progressItems)")

                }
            }
        }

    }

}

//MARK: - UITableView Delegate and Data Source

extension FeedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progressItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        
        cell.configure(with: progressItems[indexPath.row].date, with: progressItems[indexPath.row].goal, with: progressItems[indexPath.row].image, with: progressItems[indexPath.row].user)

        return cell
    }
    
    
}

