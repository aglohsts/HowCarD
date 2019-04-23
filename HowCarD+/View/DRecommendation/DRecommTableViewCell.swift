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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutCell(image: String, title: String, target: String, timePeriod: String?, note: String) {
        
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
