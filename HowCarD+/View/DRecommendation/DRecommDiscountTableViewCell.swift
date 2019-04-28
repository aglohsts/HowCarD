//
//  DRecommDiscountTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommDiscountTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var discountTitleLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutCell(image: String, title: String, bankName: String, cardName: String, timePeriod: String) {
        
        let url = URL(string: image)!
        
        rightImageView.loadImageByURL(url, placeHolder: UIImage.asset(.Image_Placeholder))
        
        discountTitleLabel.text = title
        
        targetLabel.text = "\(bankName) \(cardName)"
        
        timePeriodLabel.text = timePeriod
    }
}
