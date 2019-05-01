//
//  DisountCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountCollectionViewCell: HCBaseCollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage.asset(.Icons_Heart_Selected), for: .normal)
            } else {
                likeButton.setImage(UIImage.asset(.Icons_Heart_Normal), for: .normal)
            }
        }
    }
    
    var isRead: Bool = false {
        
        didSet {
            
            if isRead {
                
                backView.layer.backgroundColor = UIColor.white.cgColor
                
            } else {
                
                backView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC).cgColor
            }
        }
    }

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var discountTitleLabel: UILabel!

    @IBOutlet weak var targetLabel: UILabel!

    @IBOutlet weak var timePeriodLabel: UILabel!
    
    var likeBtnTouchHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellView()
    }
    
    func setCellView() {
        
        imageView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 6.0)
        
        backView.roundCorners(
            [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner],
            radius: 6.0
        )
    }

    func layoutCell(image: String, discountTitle: String, bankName: String, cardName: String, timePeriod: String, isLiked: Bool, isRead: Bool) {

        imageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        discountTitleLabel.text = discountTitle

        targetLabel.text = "\(bankName) \(cardName)"

        timePeriodLabel.text = timePeriod
        
        self.isLiked = isLiked
        
        self.isRead = isRead
    }

    @IBAction func onLike(_ sender: Any) {
        isLiked = !isLiked
        
        likeBtnTouchHandler?()
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: NotificationNames.updateLikedDiscount.rawValue),
            object: nil
        )
    }
    
    func transferToDate(unixTime: Int) -> String {

        let time = TimeInterval(unixTime)

        let date = Date(timeIntervalSince1970: time)

        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone.current

        dateFormatter.dateFormat = "yyyy/MM/dd"

        return dateFormatter.string(from: date)
    }
    
    override func prepareForReuse() {
        
        if isLiked {
            likeButton.setImage(UIImage.asset(.Icons_Heart_Selected), for: .normal)
        } else {
            likeButton.setImage(UIImage.asset(.Icons_Heart_Normal), for: .normal)
        }
        
        if isRead {
            
            backView.layer.backgroundColor = UIColor.white.cgColor
        } else {
            
            backView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC).cgColor
        }
    }
}
