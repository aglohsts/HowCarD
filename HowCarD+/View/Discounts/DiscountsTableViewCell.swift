//
//  DiscountsTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var toMoreDiscountHandler: (() -> Void)?
    
    var toDiscountDetailHandler: (() -> Void)?
    
    var discountDetails: [DiscountDetail] = []

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

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        
        collectionView.agRegisterCellWithNib(
            identifier: String(describing: DiscountCollectionViewCell.self),
            bundle: nil)
        
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    @IBAction func onViewAll(_ sender: Any) {
        toMoreDiscountHandler?()
        
//        guard let discountsVC = sender.source as? DiscountsViewController else { return }
        // sender: UIStoryboardSegue
    }
}

extension DiscountsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            return CGSize(width: UIScreen.width / 2 - 25, height: 250.0)
            
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 24.0, left: 16, bottom: 24, right: 15)
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

extension DiscountsTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        toDiscountDetailHandler?()
    }
}

extension DiscountsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discountDetails.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DiscountCollectionViewCell.self),
                for: indexPath
            )
            
            guard let discountCell = cell as? DiscountCollectionViewCell else { return cell }
            
            discountCell.layoutCell(
                image: discountDetails[indexPath.row].image,
                discountName: discountDetails[indexPath.row].name,
                target: discountDetails[indexPath.row].target,
                timePeriod: discountDetails[indexPath.row].timePeriod,
                isLiked: discountDetails[indexPath.row].isLiked
            )
            
            discountCell.touchHandler = {
                
                self.discountDetails[indexPath.row].isLiked = !self.discountDetails[indexPath.row].isLiked
            }
            
            return discountCell
    }
    
}
