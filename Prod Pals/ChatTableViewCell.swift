//
//  ChatTableViewCell.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-08.
//

import UIKit

protocol ChatTableViewCellDelegate: AnyObject {
    func didTapButton(with title: String)
}

class ChatTableViewCell: UITableViewCell{
    
    weak var delegate: ChatTableViewCellDelegate?
    
    static let identifier = "ChatTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ChatTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var chatButton: UIButton!
    private var title: String = ""
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate?.didTapButton(with: title)
    }
    
    func configure(with title: String) {
        print(title)
        chatButton.setTitle(title, for: .normal)
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
