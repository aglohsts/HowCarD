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

    func layoutCell(category: String, image: String) {
        
        label.text = category
        
        imageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder2))
    }
}
