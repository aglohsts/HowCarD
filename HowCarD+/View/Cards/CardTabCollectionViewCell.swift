//
//  CardTabCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/6.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tabLabel: UILabel!
    
    func layoutCell(tab: String) {
        
        tabLabel.text = tab
    }
}
