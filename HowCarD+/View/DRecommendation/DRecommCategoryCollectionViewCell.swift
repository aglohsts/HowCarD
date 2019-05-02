//
//  DRecommCategoryCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var discountImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var briefContentLabel: UILabel!
    
    func layoutCell(image: String, title: String, briefContent: String) {
        
        discountImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        titleLabel.text = title
        
        briefContentLabel.text = briefContent
    }
}
