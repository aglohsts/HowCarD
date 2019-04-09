//
//  FilterCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/5.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class FilterIconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var choiceImgView: UIImageView!

    @IBOutlet weak var choiceLabel: UILabel!

    func layoutCell(iconImage: UIImage, choiceTitle: String) {
        choiceImgView.image = iconImage
        choiceLabel.text = choiceTitle
    }
}
