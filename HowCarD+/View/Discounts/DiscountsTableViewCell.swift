//
//  DiscountsTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FirebaseAuth

class DiscountsTableViewCell: HCBaseTableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var toMoreDiscountHandler: (() -> Void)?
    
    var toDiscountDetailHandler: ((IndexPath) -> Void)?
    
//    var likeButtonDidTouchHandler: ((DiscountInfo, UITableViewCell) -> Void)?
    
    var isReadTouchHandler: ((IndexPath) -> Void)?
    
    var presentAuthVCHandler: (() -> Void)?
    
    var discountInfos: [DiscountInfo] = []

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        
        setViewBackground(hex: .viewBackground)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setViewBackground(hex: HCColorHex) {
        super.setViewBackground(hex: hex)
        
        self.backgroundColor = .hexStringToUIColor(hex: hex)
        
        collectionView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
    
    func layoutTableViewCell(category: String, discountInfos: [DiscountInfo]) {
        
        categoryLabel.text = category
        
        self.discountInfos = discountInfos
        
        collectionView.reloadData()
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
            
            return CGSize(width: UIScreen.width / 2 - 30, height: 220.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 24.0, left: 16, bottom: 24, right: 15)
    }
    
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int)
            -> CGFloat {
    
                return 8.0
        }
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
        
        toDiscountDetailHandler?(indexPath)
        
//        discountInfos[indexPath.row].isRead = true
        
        isReadTouchHandler?(indexPath)
    }
}

extension DiscountsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discountInfos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: DiscountCollectionViewCell.self),
                for: indexPath
            )
            
            guard let discountCollectionViewCell = cell as? DiscountCollectionViewCell else { return cell }
            
            discountCollectionViewCell.layoutCell(
                image: discountInfos[indexPath.row].image,
                discountTitle: discountInfos[indexPath.row].title,
                bankName: discountInfos[indexPath.row].bankName,
                cardName: discountInfos[indexPath.row].cardName,
                timePeriod: discountInfos[indexPath.row].timePeriod,
                isLiked: discountInfos[indexPath.row].isLiked,
                isRead: discountInfos[indexPath.row].isRead
            )
            
            discountCollectionViewCell.likeBtnTouchHandler = { [weak self] in

                if HCFirebaseManager.shared.agAuth().currentUser != nil {
                    
                    guard let strongSelf = self, let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                    
                    if strongSelf.discountInfos[indexPath.row].isLiked {
                        
                        HCFirebaseManager.shared.deleteId(
                            userCollection: .likedDiscounts,
                            uid: user.uid,
                            id: strongSelf.discountInfos[indexPath.row].discountId
                        )
                    } else {
                        
                        HCFirebaseManager.shared.addId(
                            userCollection: .likedDiscounts,
                            uid: user.uid,
                            id: strongSelf.discountInfos[indexPath.row].discountId,
                            addIdCompletionHandler: nil
                        )
                    }
                    
                    strongSelf.discountInfos[indexPath.row].isLiked = !strongSelf.discountInfos[indexPath.row].isLiked
                    
                    NotificationCenter.default.post(
                        name: Notification.Name(rawValue: NotificationNames.updateLikedDiscount.rawValue),
                        object: nil
                    )
                    
                } else {
                    
                    self?.presentAuthVCHandler?()
                }
            }

            return discountCollectionViewCell
    }
    
}
