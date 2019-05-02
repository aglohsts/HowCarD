//
//  DRecommCategoryDetailTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/1.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryDetailTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var discountImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var briefContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func layoutCell(image: String, title: String, briefContent: String) {
        
        discountImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        titleLabel.text = title
        
        briefContentLabel.text = briefContent
    }
}
