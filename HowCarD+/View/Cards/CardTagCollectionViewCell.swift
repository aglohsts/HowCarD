//
//  CardTagCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardTagCollectionViewCell: HCBaseCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewBackground(hex: .viewBackground)
    }

    @IBOutlet weak var tagLabel: UILabel!

    func layoutCell(tag: String) {

        tagLabel.text = tag
    }
    
    override func setViewBackground(hex: HCColorHex) {
        self.backgroundColor = UIColor.clear
    }

}
