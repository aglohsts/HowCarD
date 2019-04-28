//
//  FilterTextCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/5.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class FilterTextCollectionViewCell: HCBaseCollectionViewCell {

    @IBOutlet weak var choiceLabel: UILabel!

    func layoutCell(choiceTitle: String) {

        choiceLabel.text = choiceTitle
    }
}
