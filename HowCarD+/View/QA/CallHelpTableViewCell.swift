//
//  CallHelpTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CallHelpTableViewCell: UITableViewCell {

    @IBOutlet weak var bankIconImageView: UIImageView!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func layoutCell(bankIconImage: String, bankName: String, phoneNumber: String) {
        
        bankIconImageView.loadImage(bankIconImage, placeHolder: UIImage.asset(.Image_Placeholder))
        
        bankNameLabel.text = bankName
        
        phoneNumberLabel.text = phoneNumber
    }
}
