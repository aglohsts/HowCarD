//
//  CardInfoTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/5.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardInfoTableViewCell: HCBaseTableViewCell {
    
    var collectButtonDidTouchHandler: (() -> Void)?
    
    var toCardDetailHandler: (() -> Void)?
    
    var isMyCardDidTouchHandler: (() -> Void)?
    
    var toOfficialWebHandler: (() -> Void)?
    
    var toApplyCardHandler: (() -> Void)?
    
    var briefInfos: [ BriefIntro ] = []

    var tagArray = [String]() {
        
        didSet {
            self.tagCollectionView.reloadData()
        }
    }

    var isRead: Bool = false {
        
        didSet {
            if isRead {
                readMarkView.layer.backgroundColor = UIColor.lightGray.cgColor
                
                readMarkView.isHidden = true
                
                rightBackView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .markAsReadBackground).cgColor
                
                cardNameLabel.isRegularFont(size: 14)

            } else {
                readMarkView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .tint).cgColor
            }
        }
    }
    
    var isCollected: Bool = false {
        
        didSet {
            
            if isCollected {
                
                collectedBtn.setImage(UIImage.asset(.Icons_Bookmark_Saved), for: .normal)
            } else {
                
                collectedBtn.setImage(UIImage.asset(.Icons_Bookmark_Normal), for: .normal)
            }
        }
    }
    
    var isMyCard: Bool = false {
        
        didSet {
            
            if isMyCard {
                
                isMyCardBtn.setImage(UIImage.asset(.Icons_isMyCard_Selected), for: .normal)
            } else {
                
                isMyCardBtn.setImage(UIImage.asset(.Icons_isMyCard_Normal), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var toOfficialWebBtn: UIButton!
    
    @IBOutlet weak var toApplyCardBtn: UIButton!
    
    @IBOutlet weak var collectedBtn: UIButton!
    
    @IBOutlet weak var isMyCardBtn: UIButton!

    @IBOutlet weak var leftBackView: UIView!
    
    @IBOutlet weak var rightBackView: UIView!

    @IBOutlet weak var readMarkView: UIView!

    @IBOutlet weak var bankNameLabel: UILabel!

    @IBOutlet weak var cardImageView: UIImageView!

    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var cardInfoCollectionView: UICollectionView! {
        
        didSet {
            
            cardInfoCollectionView.delegate = self
            
            cardInfoCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        
        didSet {
            tagCollectionView.delegate = self

            tagCollectionView.dataSource = self
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
        
        layoutView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func layoutCell(
        isRead: Bool,
        isCollected: Bool,
        isMyCard: Bool,
        bankName: String,
        cardName: String,
        cardImage: String,
        tags: [String],
        briefInfos: [ BriefIntro ]
        ) {

        self.isRead = isRead

        self.isCollected = isCollected
        
        self.isMyCard = isMyCard

//        bankIconImageView.image = bankIcon

        bankNameLabel.text = bankName
        
        cardNameLabel.text = cardName

        cardImageView.loadImage(cardImage)
        
        self.tagArray = tags
        
        self.briefInfos = briefInfos
    }

    func setupCollectionView() {
        
        tagCollectionView.agRegisterCellWithNib(
            identifier: String(describing: CardTagCollectionViewCell.self),
            bundle: nil
        )
        
        cardInfoCollectionView.agRegisterCellWithNib(
            identifier: String(describing:
                BriefInfoCollectionViewCell.self),
            bundle: nil
        )
        
        tagCollectionView.showsHorizontalScrollIndicator = false
        
        cardInfoCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func onCollectCard(_ sender: Any) {
        
        collectButtonDidTouchHandler?()
    }
    
    @IBAction func onIsMyCard(_ sender: Any) {
        
        isMyCardDidTouchHandler?()
    }
    
    @IBAction func onToOfficialWeb(_ sender: Any) {
        
        toOfficialWebHandler?()
    }
    
    @IBAction func onToApplyCard(_ sender: Any) {
    
        toApplyCardHandler?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        DispatchQueue.main.async { [weak self] in
            
            self?.cardInfoCollectionView.reloadData()
            
            self?.tagCollectionView.reloadData()
        }
        
    }
}

extension CardInfoTableViewCell {
    
    func layoutView() {
        
        leftBackView.roundCorners(
            [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner],
            radius: 5.0
        )
        
        rightBackView.roundCorners(
            [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner],
            radius: 8.0
        )
        
        readMarkView.isRoundedView()
        
        toOfficialWebBtn.isRoundedView()
        
        toApplyCardBtn.isRoundedView()

    }
}

extension CardInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            switch collectionView {
                
            case tagCollectionView:
                
                return CGSize(
                    width: tagCollectionView.frame.width / 5,
                    height: tagCollectionView.frame.height
                )
                
            case cardInfoCollectionView:
                
                return CGSize(
                    width: cardInfoCollectionView.frame.width / 3 - 20,
                    height: cardInfoCollectionView.frame.height
                )
                
            default: return CGSize.zero
            }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            switch collectionView {
                
            case tagCollectionView:
                
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
            case cardInfoCollectionView:
                
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            default: return UIEdgeInsets.zero
            }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
        -> CGFloat {
            
            switch collectionView {
                
            case tagCollectionView:
                
                return 4.0
                
            case cardInfoCollectionView:
                
                return 4.0
                
            default: return 0
            }
    }
    //
    //    func collectionView(
    //        _ collectionView: UICollectionView,
    //        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int)
    //        -> CGFloat {
    //
    //
    //    }
    //
    //    func collectionView(
    //        _ collectionView: UICollectionView,
    //        layout collectionViewLayout: UICollectionViewLayout,
    //        referenceSizeForHeaderInSection section: Int)
    //        -> CGSize {
    //
    //            return CGSize(width: UIScreen.width, height: 25.0)
    //    }
}

extension CardInfoTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case cardInfoCollectionView:
            
            if indexPath.item == briefInfos.count {
                
                toCardDetailHandler?()
            }
            
        default: return
        }
    }
}

extension CardInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case cardInfoCollectionView: return briefInfos.count + 1
            
        case tagCollectionView: return tagArray.count
            
        default: return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        switch collectionView {
            
        case cardInfoCollectionView:
            
            if indexPath.item == briefInfos.count {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ToMoreInfoCollectionViewCell.self),
                    for: indexPath
                )
                
                guard let moreInfoCell = cell as? ToMoreInfoCollectionViewCell else { return cell }
                
                return moreInfoCell
                
            } else {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: BriefInfoCollectionViewCell.self),
                    for: indexPath
                )
                
                guard let briefInfoCell = cell as? BriefInfoCollectionViewCell else { return cell }
                
                briefInfoCell.layoutCell(
                    title: briefInfos[indexPath.item].title,
                    content: briefInfos[indexPath.item].content)
                
                return briefInfoCell
            }
            
        case tagCollectionView:
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CardTagCollectionViewCell.self),
                for: indexPath
            )
            
            guard let tagCell = cell as? CardTagCollectionViewCell else { return cell }
            
            tagCell.layoutCell(tag: tagArray[indexPath.item])
            
            return tagCell
            
        default:
            
            return UICollectionViewCell()
        }
    }
}
