//
//  MoreInfoCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class ToMoreInfoCollectionViewCell: HCBaseCollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewBackground(hex: .viewBackground)
    }
    
    override func setViewBackground(hex: HCColorHex) {
        
        self.backgroundColor = UIColor.clear
    }
}
