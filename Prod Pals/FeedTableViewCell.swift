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
    
    func configure(with date: String, with goal: String, with image: String, with user: String) {
        let url = URL(string: image)!
        
        nameLabel.text = user
        goalLabel.text = goal
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let data = data {
                
                DispatchQueue.main.async() { [weak self] in
                            self?.progressImage.image = UIImage(data: data)
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
    
}
