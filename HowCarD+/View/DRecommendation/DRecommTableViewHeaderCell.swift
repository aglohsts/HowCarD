//
//  DRecommTableViewCell.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FoldingCell

class DRecommTableViewHeaderCell: FoldingCell {

//    @IBOutlet override var foregroundView: RotatedView!
    
//        {
//        didSet {
//
//            foregroundView.layer.cornerRadius = 10
//
//        }
//    }
    
//    @IBOutlet override var containerView: UIView!
    
//    fileprivate struct C {
//        struct CellHeight {
//            static let close: CGFloat = 138 // equal or greater foregroundView height
//            static let open: CGFloat = 166 // equal or greater containerView height
//        }
//    }
//    
//    var cellHeights = (0...3).map { _ in C.CellHeight.close }
    
    
    
    
    
//    @IBOutlet weak var bannerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        durationsForExpandedState = [0.26, 0.2, 0.2]
        durationsForCollapsedState = [0.26, 0.2, 0.2]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func layoutCell(image: UIImage, title: String) {

//        bannerImageView.image = image

//        bannerLabel.text = title
    }

}


