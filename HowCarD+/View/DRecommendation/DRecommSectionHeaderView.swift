//
//  DRecommSectionHeaderView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionHeaderLabel: UILabel!
    
    func layoutView(category: String) {
        
        sectionHeaderLabel.text = category
    }

}
