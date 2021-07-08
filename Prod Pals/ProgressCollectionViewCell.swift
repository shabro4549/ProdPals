//
//  ProgressCollectionViewCell.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2021-02-10.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progressImage: UIImageView!
//    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    let date = Date()
    
    static let identifier = "ProgressCollectionViewCell"
    
    func configure(with image: UIImage) {
        progressImage.image = image
        progressLabel.text = "Apr 1, 2021"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}


