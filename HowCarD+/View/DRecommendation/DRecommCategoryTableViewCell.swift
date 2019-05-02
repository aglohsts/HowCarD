//
//  DRecommCategoryTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/1.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryTableViewCell: HCBaseTableViewCell {
    
    var cellTouchHandler: ((String) -> Void)?
    
    var dRecommSection: DRecommSectionContent? {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
    }
    
    var subCategory: [DRecommSubCategory] = [] {
        
        didSet {
            
            DispatchQueue.main.async {

                self.collectionView.reloadData()
            }
        }
    }
    
    var subTitle: String = "" {
        
        didSet {
            
            subTitleLabel.text = subTitle
        }
    }

    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setViewBackground(hex: HCColorHex) {
        super.setViewBackground(hex: hex)
        
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC)
    }
    
    func layoutCell(subCategory: [DRecommSubCategory], subTitle: String) {

        self.subCategory = subCategory
        
        self.subTitle = subTitle
    }
}

// inner collectionView
extension DRecommCategoryTableViewCell {
    
    private func setupCollectionView() {

    }
}

extension DRecommCategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            return CGSize(width: UIScreen.width / 2 - 60, height: (UIScreen.width / 2 - 60) * 1.3)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    //
    //    func collectionView(
    //        _ collectionView: UICollectionView,
    //        layout collectionViewLayout: UICollectionViewLayout,
    //        minimumLineSpacingForSectionAt section: Int)
    //        -> CGFloat {
    //
    //            return 15.0
    //    }
    //
    //    func collectionView(
    //        _ collectionView: UICollectionView,
    //        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int)
    //        -> CGFloat {
    //
    //            return 15.0
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

extension DRecommCategoryTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        cellTouchHandler?(subCategory[indexPath.section].subContent.discountInfos[indexPath.item].discountId)
    }
}

extension DRecommCategoryTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return subCategory[section].subContent.discountInfos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DRecommCategoryCollectionViewCell.self),
            for: indexPath
        )
        
        guard let discountCollectionViewCell = cell as? DRecommCategoryCollectionViewCell else { return cell }
        
        discountCollectionViewCell.layoutCell(
            image: subCategory[indexPath.section].subContent.discountInfos[indexPath.row].image,
            title: subCategory[indexPath.section].subContent.discountInfos[indexPath.row].cardName,
            briefContent: subCategory[indexPath.section].subContent.discountInfos[indexPath.row].title
        )
        
        return discountCollectionViewCell
    }
}
