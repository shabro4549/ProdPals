//
//  MessageTableViewCell.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-16.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    static let identifier = "MessageTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MessageTableViewCell", bundle: nil)
    }

    @IBOutlet weak var senderProfile: UIImageView!
    @IBOutlet weak var senderMessage: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userMessage: UILabel!
    
    func configure(with message: String, with sender: String, with authedUser: String) {
        if authedUser == sender {
            senderProfile.alpha = 0
            senderMessage.alpha = 0
            userProfile.alpha = 1
            userProfile.alpha = 1
            userMessage.text = message
        } else {
            senderProfile.alpha = 1
            senderMessage.alpha = 1
            userProfile.alpha = 0
            userMessage.alpha = 0
            senderMessage.text = message
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
