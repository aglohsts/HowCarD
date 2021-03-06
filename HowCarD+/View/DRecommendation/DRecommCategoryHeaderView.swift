//
//  DRecommCategoryHeaderView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/1.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerBackView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 14.5
        )
        
        imageView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 10
        )
        
        imageBackView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 10
        )
        
//        headerBackView.backgroundColor = UIColor.hexStringToUIColor(hex: .darkblue)
        
        imageBackView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayEFF2F4)
    }
    
    func layoutView(image: String, headerTitle: String) {
        
        imageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        headerTitleLabel.text = headerTitle
    }
}
