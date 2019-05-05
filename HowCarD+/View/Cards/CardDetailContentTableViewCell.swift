//
//  CardDetailContentTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardDetailContentTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var arrowButton: UIButton!
    
    @IBOutlet weak var contentBackView: UIView!
    
    var detailObservationToken: NSKeyValueObservation?

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
        
        detailKVO()
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
        
        if contentLabel.text == nil {

            self.arrowButton.isHidden = true

            self.contentLabel.isHidden = true

            self.contentBackView.isHidden = true

        } else {
        
            self.arrowButton.isHidden = false
            
            self.contentLabel.isHidden = false
            
            self.contentBackView.isHidden = false
        }
    }
    
    func detailKVO() {
        
        detailObservationToken =  observe(\.contentLabel.text, options: [.old, .new]) { (strongSelf, change) in
            // return token
            
            if change.newValue == nil {

                self.arrowButton.isHidden = true

                self.contentLabel.isHidden = true

                self.contentBackView.isHidden = true

                DispatchQueue.main.async {

                    self.reloadInputViews()
                }
            }
            
            if change.oldValue == nil {
                
                self.arrowButton.isHidden = true
                
                self.contentLabel.isHidden = true
                
                self.contentBackView.isHidden = true
                
                DispatchQueue.main.async {
                    
                    self.reloadInputViews()
                }
            } else {
                
                self.arrowButton.isHidden = false
                
                self.contentLabel.isHidden = false
                
                self.contentBackView.isHidden = false
                
                DispatchQueue.main.async {
                    
                    self.reloadInputViews()
                }
            }
            

        }
    }
}
