//
//  DRecommTableViewCell.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView! {
        didSet {
            
            bannerImageView.layer.cornerRadius = 10
            
        }
    }
    
    @IBOutlet weak var bannerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutCell(image: UIImage, title: String){
        
        bannerImageView.image = image
        
        bannerLabel.text = title
    }

}
