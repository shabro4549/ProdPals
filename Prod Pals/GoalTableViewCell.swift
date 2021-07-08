//
//  GoalTableViewCell.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2020-12-15.
//

import UIKit

protocol GoalTableViewCellDelegate: AnyObject {
    func didTapButton(with title: String)
}

class GoalTableViewCell: UITableViewCell {
    
    weak var delegate: GoalTableViewCellDelegate?
    
    static let identifier = "GoalTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "GoalTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var bigGoalButton: UIButton!
    private var title: String = ""

    @IBAction func didTapButton() {
        delegate?.didTapButton(with: title)
    }
    
    func configure(with title: String) {
        self.title = title
        bigGoalButton.setTitle(title, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        
    }
    
}
