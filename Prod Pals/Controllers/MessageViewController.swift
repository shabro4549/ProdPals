//
//  MessageViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-08.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {

    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var selectedChat = ""
    var messages: [Message] = []
    var goalUsers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.register(MessageTableViewCell.nib(), forCellReuseIdentifier: MessageTableViewCell.identifier)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        self.navigationItem.title = selectedChat
        loadMessages()

    }
    
    @IBAction func sendPressed(_ sender: Any) {
    }
    
    func loadMessages() {
        print("load messages, selected chat = \(selectedChat)")
        print(goalUsers)
        print("\(goalUsers)+\(selectedChat)")
        db.collection("chats").document("\(goalUsers)+\(selectedChat)").collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore when loading feed for FeedViewController. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {

                    for doc in snapshotDocuments {
                        
                        let data = doc.data()
                        
                        if let dateData = data["date"] as? TimeInterval, let messageData = data["content"] as? String, let senderData = data["sender"] as? String {
                            
                            self.messages.append(Message(date: dateData, message: messageData, sender: senderData))
                            
                            DispatchQueue.main.async {
                                self.messageTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

}

//MARK: - UITableView Delegate and Datasource

extension MessageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("These are the messages ... \(messages)")
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        if let userEmail = user?.email {
            cell.configure(with: messages[indexPath.row].message, with: messages[indexPath.row].sender, with: userEmail)
        }
        return cell
    }
}

