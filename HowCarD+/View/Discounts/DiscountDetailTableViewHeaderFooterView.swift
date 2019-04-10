//
//  DiscountDetailTableViewHeaderFooterView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountDetailTableViewHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!

    func layoutView(contentTitle: String) {
        
        label.text = contentTitle
    }
}
