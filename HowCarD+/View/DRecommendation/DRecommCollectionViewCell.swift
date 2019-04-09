//
//  DRecommCollectionViewCell.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var imageView: UIImageView!

    func layoutCell() {
        label.text = "123"
//        imageView.image = UIImage.asset(.Image_Placeholder)
    }
}
