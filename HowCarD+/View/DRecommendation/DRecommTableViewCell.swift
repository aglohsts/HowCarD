//
//  DRecommTableViewContentCell.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FoldingCell

class DRecommTableViewCell: FoldingCell {
    
    @IBOutlet weak var foreImageView: UIImageView!

    @IBOutlet weak var foreTitleLabel: UILabel!

    @IBOutlet weak var foreTargetLabel: UILabel!

    @IBOutlet weak var containerImageView: UIImageView!

    @IBOutlet weak var containerTitleLabel: UILabel!

    @IBOutlet weak var containerTargetLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutCell(image: String, title: String, target: String) {
        
        foreImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        containerImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        foreTitleLabel.text = title
        
        containerTitleLabel.text = title
        
        foreTargetLabel.text = target
        
        containerTargetLabel.text = target
    }

}
