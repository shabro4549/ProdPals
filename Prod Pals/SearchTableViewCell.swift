//
//  SearchTableViewCell.swift
//  Something
//
//  Created by Shannon Brown on 2021-07-09.
//

import UIKit

protocol SearchTableViewCellDelegate : AnyObject {
    func didTapButton(with title: String)
}

class SearchTableViewCell: UITableViewCell {
    weak var delegate: SearchTableViewCellDelegate?
    
    static let identifier = "SearchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchTableViewCell", bundle: nil)
    }
    

    @IBOutlet weak var usernameButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    private var title: String = ""
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate?.didTapButton(with: title)
    }
    
    func configure(with title: String, with image: String) {
        self.title = title
        let url = URL(string: image)!
        
        usernameButton.setTitle(title, for: .normal)
        
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
    
}
