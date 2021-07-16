//
//  SelectedUserTableViewCell.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-15.
//

import UIKit

class SelectedUserTableViewCell: UITableViewCell {
    
    static let identifier = "SelectedUserTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SelectedUserTableViewCell", bundle: nil)
    }

    @IBOutlet weak var usernameLabel: UILabel!
    
    private var title: String = ""
    
    func configure(with title: String) {
        self.title = title
        usernameLabel.text = title
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
