//
//  GoalSearchTableViewCell.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-15.
//

import UIKit

protocol GoalSearchTableViewCellDelegate : AnyObject {
    func didTapButton(with title: String)
}

class GoalSearchTableViewCell: UITableViewCell {
    weak var delegate: GoalSearchTableViewCellDelegate?
    
    static let identifier = "GoalSearchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "GoalSearchTableViewCell", bundle: nil)
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    private var title: String = ""
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate?.didTapButton(with: title)
    }
    
    func configure(with title: String, with image: String) {
        self.title = title
        let url = URL(string: image)!
        
        usernameLabel.text = title
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let data = data {
                DispatchQueue.main.async() { [weak self] in
                            self?.profileImage.image = UIImage(data: data)
                        }

            } else {
                print(error!)
            }
        }.resume()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func addPressed(_ sender: Any) {
//        print("Selected user ... \(usernameLabel.text)")
//    }
    
}
