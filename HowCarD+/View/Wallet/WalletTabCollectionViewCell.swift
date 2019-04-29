//
//  WalletTabCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class WalletTabCollectionViewCell: HCBaseCollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let bottomBorder = CALayer()
    
    let borderWidth = CGFloat(1.0)
    
    override var isSelected: Bool {
        
        didSet {
            if isSelected {
                
                self.bottomBorder.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1).cgColor
            } else {
                
                self.bottomBorder.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC).cgColor
            }
        }
    }
    
    func layoutCell(imageAsset: ImageAsset) {
        
        imageView.image = UIImage.asset(imageAsset)
        
        // MARK: - Cell Bottom Border
        
        self.bottomBorder.frame = CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth)
        
        self.layer.masksToBounds = true
        
        self.layer.addSublayer(bottomBorder)
    }
}
