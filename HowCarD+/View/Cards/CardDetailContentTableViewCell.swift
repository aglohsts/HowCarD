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
    
    
    
    var isDetailAvailable: Bool = false {
        
        didSet {
            
            if isDetailAvailable {
                
                self.arrowButton.isHidden = false
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.reloadInputViews()
                }
            } else {
                
                self.arrowButton.isHidden = true
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.reloadInputViews()
                }
            }
        }
    }
    
    var detailObservationToken: NSKeyValueObservation?

    var isDetail: Bool = false {
        didSet {
  
            if isDetail {
                
                arrowButton.setImage(UIImage.asset(.Icons_ArrowUp), for: .normal)
                
                contentBackView.backgroundColor = UIColor.hexStringToUIColor(hex: .tintBackground)
            } else {
                arrowButton.setImage(UIImage.asset(.Icons_ArrowDown), for: .normal)
                
                contentBackView.backgroundColor = UIColor.white
            }
        }
    }

    var showDetailDidTouchHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutView()
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

    func layoutCell(title: String, content: String?, isDetail: Bool, isDetailAvailable: Bool) {

        titleLabel.text = title

        contentLabel.text = content

        self.isDetail = isDetail
        
        self.isDetailAvailable = isDetailAvailable
    }
    
    func layoutView() {
        
        contentBackView.roundCorners(
            [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner],
            radius: 10)
    }
    
    override func prepareForReuse() {
        
        if isDetailAvailable {
            
            self.arrowButton.isHidden = false
            
        } else {
            
            self.arrowButton.isHidden = true
            
        }
    }
}
