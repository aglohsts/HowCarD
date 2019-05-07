//
//  DRecommCollectionViewCell.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCollectionViewCell: HCBaseCollectionViewCell {

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.isRoundedImage()
    }
    
    func layoutCell(category: String, image: ImageAsset) {
        
        label.text = category
        
        imageView.image = UIImage.asset(image)
        
//        imageView.loadImageByURL(image, placeHolder: UIImage.asset(.Image_Placeholder2))
        
//        imageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder2))
    }
}
