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
    
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellView()
    }
    
    func setCellView() {
        
        backView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 6.0)
        
        discountImageView.roundCorners(
            [.layerMaxXMinYCorner, .layerMinXMinYCorner],
            radius: 6.0)
    }
    
    func layoutCell(image: String, title: String, briefContent: String) {
        
        discountImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        titleLabel.text = title
        
        briefContentLabel.text = briefContent
    }
}
