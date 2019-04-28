//
//  BriefInfoCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class BriefInfoCollectionViewCell: HCBaseCollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func layoutCell(title: String, content: String) {
        
        titleLabel.text = title
        
        contentLabel.text = content
    }
}
