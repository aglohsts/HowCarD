//
//  HCBaseCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/29.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class HCBaseCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewBackground(hex: .viewBackground)
    }
    
    func setViewBackground(hex: HCColorHex) {
        
        backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        contentView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }
}
