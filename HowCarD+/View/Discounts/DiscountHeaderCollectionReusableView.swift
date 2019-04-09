//
//  DiscountHeaderCollectionReusableView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func layoutView(category: String) {

        categoryLabel.text = category
    }

    @IBAction func onViewAll(_ sender: Any) {
    }

}
