//
//  LikedDiscountTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class LikedDiscountTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var discountTitleLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    @IBOutlet weak var discountImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutCell(discountTitle: String, bankName: String, cardName: String, timePeriod: String, discountImage: String) {
        
        discountTitleLabel.text = discountTitle
        
        targetLabel.text = "\(bankName) \(cardName)"
        
        timePeriodLabel.text = timePeriod
        
        discountImageView.loadImage(discountImage, placeHolder: UIImage.asset(.Image_Placeholder2))
    }

}
