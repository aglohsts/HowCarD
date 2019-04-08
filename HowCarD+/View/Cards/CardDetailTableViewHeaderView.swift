//
//  CardDetailTitleTableViewHeaderView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardDetailTableViewHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    func layoutView(title: String){
        titleLabel.text = title
    }
}
