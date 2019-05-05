//
//  DRecommTableViewContentCell.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FoldingCell

class DRecommTableViewCell: FoldingCell {
    
    var tagArray = [String]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.foreCollectionView.reloadData()
                
                self.containerCollectionView.reloadData()
            }
        }
    }
    
    var briefIntroArray = [BriefIntro]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.briefIntroCollectionView.reloadData()
            }
        }
    }
    
    var toDetailHandler: (() -> Void)?
    
    @IBOutlet weak var foreImageView: UIImageView!

    @IBOutlet weak var foreTitleLabel: UILabel!

    @IBOutlet weak var foreTargetLabel: UILabel!
    
    @IBOutlet weak var foreTimePeriodLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var foreCollectionView: UICollectionView! {
        
        didSet {
            
            foreCollectionView.delegate = self
            
            foreCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var containerImageView: UIImageView!

    @IBOutlet weak var containerTitleLabel: UILabel!

    @IBOutlet weak var containerTargetLabel: UILabel!

    @IBOutlet weak var containerTimePeriodLabel: UILabel!
    
    @IBOutlet weak var containerCollectionView: UICollectionView! {
        
        didSet {
            containerCollectionView.delegate = self
            
            containerCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var briefIntroCollectionView: UICollectionView! {
        
        didSet {
            
            briefIntroCollectionView.delegate = self
            
            briefIntroCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var foreMarkIsReadView: UIView!
    
    @IBOutlet weak var containerMarkIsReadView: UIView!
    
    var isRead: Bool = false {
        
        didSet {
            
            if isRead {
                
//                foreMarkIsReadView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .grayEFF2F4).cgColor
                
//                containerMarkIsReadView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .grayEFF2F4).cgColor
                
                foreMarkIsReadView.isHidden = true
                
                containerMarkIsReadView.isHidden = true
                
//                foregroundView.backgroundColor = UIColor.hexStringToUIColor(hex: .markAsReadBackground)
                
//                containerView.backgroundColor = UIColor.hexStringToUIColor(hex: .markAsReadBackground)
                
                foreTitleLabel.isRegularFont(size: 13)
                
                containerTitleLabel.isRegularFont(size: 13)
                
            } else {
                
                foreMarkIsReadView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .tint).cgColor
                
                containerMarkIsReadView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: .tint).cgColor
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        
        self.backgroundColor = UIColor.hexStringToUIColor(hex: .viewBackground)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func layoutCell() {
        
        foregroundView.roundCorners([.layerMaxXMaxYCorner], radius: 20.0)
        
        containerView.roundCorners([.layerMaxXMaxYCorner], radius: 20.0)
    }
    
    func layoutCell(image: String, title: String, target: String, timePeriod: String?, note: String, isRead: Bool) {
        
        foreImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        containerImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        foreTitleLabel.text = title
        
        containerTitleLabel.text = title
        
        foreTargetLabel.text = target
        
        containerTargetLabel.text = target
        
        if timePeriod != nil {
            foreTimePeriodLabel.text = timePeriod!
            
            containerTimePeriodLabel.text = timePeriod!
        } else {
            
            foreTimePeriodLabel.isHidden = true
            
            containerTimePeriodLabel.isHidden = true
        }
        
        noteLabel.text = note
        
        self.isRead = isRead
    }
    
    func layoutCollectionView(briefIntroArray: [BriefIntro], tagArray: [String]?) {
        
        if tagArray != nil {
            self.tagArray = tagArray!
        } else {
            
            foreCollectionView.isHidden = true
            
            containerCollectionView.isHidden = true
        }
        
        self.briefIntroArray = briefIntroArray
    }
    
    func setupCollectionView() {
        
        foreCollectionView.agRegisterCellWithNib(
            identifier: String(describing:
                CardTagCollectionViewCell.self),
            bundle: nil
        )
        
        containerCollectionView.agRegisterCellWithNib(
            identifier: String(describing:
                CardTagCollectionViewCell.self),
            bundle: nil
        )
        
        briefIntroCollectionView.agRegisterCellWithNib(
            identifier: String(describing:
                BriefInfoCollectionViewCell.self),
            bundle: nil
        )
        
        foreCollectionView.showsHorizontalScrollIndicator = false
        
        containerCollectionView.showsHorizontalScrollIndicator = false
        
        briefIntroCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func prepareForReuse() {

//        isUnfolded = false

    }
}

extension DRecommTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            switch collectionView {
                
            case foreCollectionView:
                
                return CGSize(width: foreCollectionView.frame.width / 3 - 20, height: foreCollectionView.frame.height)
                
            case containerCollectionView:
                
                return CGSize(
                    width: containerCollectionView.frame.width / 3 - 20,
                    height: containerCollectionView.frame.height
                )
                
            case briefIntroCollectionView:
                
                return CGSize(
                    width: briefIntroCollectionView.frame.width / 3 - 20,
                    height: briefIntroCollectionView.frame.height
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
                
            case foreCollectionView:
                
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
            case containerCollectionView:
                
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
            case briefIntroCollectionView:
                
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
                
            case foreCollectionView:
                
                return 5.0
                
            case containerCollectionView:
                
                return 5.0
                
            case briefIntroCollectionView:
                
                return 5.0
                
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

extension DRecommTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == briefIntroCollectionView {
            
            if indexPath.item == briefIntroArray.count {
                
                toDetailHandler?()
            }
        }
    }
}

extension DRecommTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case foreCollectionView, containerCollectionView:
            
            return tagArray.count
            
        case briefIntroCollectionView:
            
            return briefIntroArray.count + 1
            
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        switch collectionView {
            
        case foreCollectionView, containerCollectionView:
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CardTagCollectionViewCell.self),
                for: indexPath
            )
            
            guard let tagCell = cell as? CardTagCollectionViewCell else { return cell }
            
            if tagArray != [] {
                tagCell.layoutCell(tag: tagArray[indexPath.item])
            }
            
            return tagCell
        
        case briefIntroCollectionView:
            
            switch indexPath.item {
                
            case briefIntroArray.count:
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ToMoreInfoCollectionViewCell.self),
                    for: indexPath
                )
                
                guard let toMoreInfoCell = cell as? ToMoreInfoCollectionViewCell else { return cell }
                
                return toMoreInfoCell
                
            default:
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: BriefInfoCollectionViewCell.self),
                    for: indexPath
                )
                
                guard let briefIntroCell = cell as? BriefInfoCollectionViewCell else { return cell }
                
                briefIntroCell.layoutCell(
                    title: briefIntroArray[indexPath.item].title,
                    content: briefIntroArray[indexPath.item].content
                )
                
                return briefIntroCell
            }
        
        default:
            
            return UICollectionViewCell()
        }
    }
}
