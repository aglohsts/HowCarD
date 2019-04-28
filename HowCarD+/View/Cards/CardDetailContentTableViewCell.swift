//
//  CardDetailContentTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardDetailContentTableViewCell: HCTableViewCell {

    @IBOutlet weak var arrowButton: UIButton!

    var briefInfo: String = ""

    var detailInfo: String = ""

    var isDetail: Bool = false {
        didSet {
  
            if isDetail {
                
                arrowButton.setImage(UIImage.asset(.Icons_ArrowUp), for: .normal)
                
                //                contentLabel.text = detailInfo
            } else {
                arrowButton.setImage(UIImage.asset(.Icons_ArrowDown), for: .normal)
                
                //                contentLabel.text = briefInfo
            }
        }
    }

    var showDetailDidTouchHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var contentLabel: UILabel!

    @IBAction func onShowDetail(_ sender: Any) {
        
        self.reloadInputViews()

        showDetailDidTouchHandler?()

    }

    func layoutCell(title: String, content: String?, isDetail: Bool) {

        titleLabel.text = title

        contentLabel.text = content

        self.isDetail = isDetail
    }
    
    override func prepareForReuse() {
        
        arrowButton.isHidden = false
    }
}
