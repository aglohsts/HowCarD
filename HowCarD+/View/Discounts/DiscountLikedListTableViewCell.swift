//
//  DiscountLikedListTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountLikedListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var discountNameLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
