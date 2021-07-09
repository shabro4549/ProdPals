//
//  FeedTableViewCell.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-08.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var progressImage: UIImageView!
    
//    func configure(with goal: String, with user: String) {
//        nameLabel.text = user
//        goalLabel.text = goal
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
