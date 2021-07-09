//
//  ChatViewController.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-08.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var ifEmptyLabel: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    var goalColours = [#colorLiteral(red: 1, green: 0.6235294118, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.7921568627, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 1, green: 0.4196078431, blue: 0.4196078431, alpha: 1), #colorLiteral(red: 0.2823529412, green: 0.8588235294, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.1137254902, green: 0.8196078431, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0, green: 0.8235294118, blue: 0.8274509804, alpha: 1), #colorLiteral(red: 0.3294117647, green: 0.6274509804, blue: 1, alpha: 1), #colorLiteral(red: 0.3725490196, green: 0.1529411765, blue: 0.8039215686, alpha: 1)]
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.register(ChatTableViewCell.nib(), forCellReuseIdentifier: ChatTableViewCell.identifier)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITableView Delegate & Data Source Methods

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell

        cell.configure(with: "Chats")
        cell.chatButton.backgroundColor = goalColours.randomElement()
        cell.chatButton.layer.cornerRadius = 20
        cell.chatButton.layer.masksToBounds = true
        return cell
    }
    
    
}

