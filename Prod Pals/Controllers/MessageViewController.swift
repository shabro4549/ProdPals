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
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var selectedChat = ""
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.register(MessageTableViewCell.nib(), forCellReuseIdentifier: MessageTableViewCell.identifier)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        self.navigationItem.title = selectedChat

    }
    
    @IBAction func sendPressed(_ sender: Any) {
    }
    
    func loadMessages() {
        
    }

}

//MARK: - UITableView Delegate and Datasource

extension MessageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.configure(with: "What up yo", with: "no image", with: "1@2.com", with: "No one")
        return cell
    }


}

