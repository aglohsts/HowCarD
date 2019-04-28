//
//  DiscountDetailTableViewHeaderFooterView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class HCTableViewSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewBackground(hex: .viewBackground)
    }

    func layoutView(contentTitle: String) {
        
        label.text = contentTitle
    }
    
    func setViewBackground(hex: HCColorHex) {
        
        backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }

}
