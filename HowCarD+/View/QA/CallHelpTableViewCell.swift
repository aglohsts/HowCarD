//
//  CallHelpTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CallHelpTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var bankIconImageView: UIImageView!
    
    @IBOutlet weak var bankIdLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    
    var phoneNum: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutCell()
    }
    
    private func layoutCell() {
        
        backView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 4.0)
        
        bankIconImageView.roundCorners(
            [.layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 4.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func layoutCell(bankIconImage: String, bankName: String, bankId: String, phoneNumber: String) {
        
        bankIconImageView.loadImage(bankIconImage, placeHolder: UIImage.asset(.Image_Placeholder))
        
        bankIdLabel.text = bankId
        
        bankNameLabel.text = bankName
        
        phoneNum = phoneNumber
    }
    
    @IBAction func onCall(_ sender: UIButton) {
        
        guard let number = URL(string: "tel://" + phoneNum) else { return }
        UIApplication.shared.open(number)
    }
}
