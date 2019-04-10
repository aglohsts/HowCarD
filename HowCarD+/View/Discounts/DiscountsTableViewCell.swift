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
}

extension DiscountsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            return CGSize(width: UIScreen.width / 2 - 20, height: 300.0)
            
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 24.0, left: 10, bottom: 24, right: 10)
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
    
}

extension DiscountsTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
                
                // 1577750400: 2019/12/31 but shows 2020/12/31
                // 1577664000: 2019/12/30 but shows 2020/12/30
                // 1577577600: 2019/12/29 but shows 2020/12/29
                // 1575072000: 2019/11/30 (ok)
                // 1546300800: 2019/1/1 (ok)
                // 1548892800: 2019/1/31 (ok)
                
                // 1609372800: 2020/12/31 but shows 2021/12/31
                
                // 1546214400: 2018/12/31 but shows 2019/12/31
                // 1546128000: 2018/12/30 but shows 2019/12/30
                // 1546041600: 2018/12/29 (ok)
                // 1514764800: 2018/1/1 (ok)
                
            )
            
            discountCell.touchHandler = {
                
                self.discountDetails[indexPath.row].isLiked = !self.discountDetails[indexPath.row].isLiked
            }
            
            return discountCell
    }
    
}
