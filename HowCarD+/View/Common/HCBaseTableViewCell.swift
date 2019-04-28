//
//  HCTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/28.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class HCBaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewBackground(hex: .viewBackground)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setViewBackground(hex: HCColorHex) {
        
        backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        contentView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }

}
