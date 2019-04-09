//
//  DisountCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var discountNameLabel: UILabel!

    @IBOutlet weak var targetLabel: UILabel!

    @IBOutlet weak var timePeriodLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0)

    }

    func layoutCell(image: UIImage, discountName: String, target: String, timePeriod: Int) {

        imageView.image = image
        
        discountNameLabel.text = discountName

        targetLabel.text = target

        timePeriodLabel.text = "至\(transferToDate(unixTime: timePeriod))"
    }

    func transferToDate(unixTime: Int) -> String {

        let time = TimeInterval(unixTime)

        let date = Date(timeIntervalSince1970: time)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "YYYY/MM/dd"

        return dateFormatter.string(from: date)
    }
}
