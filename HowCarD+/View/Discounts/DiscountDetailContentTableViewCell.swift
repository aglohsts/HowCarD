//
//  DiscountDetailContentTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountDetailContentTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var contentBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layoutView()
        
        setViewBackground(hex: .viewBackground)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutCell(content: String) {
        label.text = content
    }
    
    func layoutView() {
        
        contentBackView.roundCorners(
            [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner],
            radius: 10)
    }
    
    override func setViewBackground(hex: HCColorHex) {
        self.backgroundColor = UIColor.clear
        
        contentBackView.backgroundColor = UIColor.white
    }

}
