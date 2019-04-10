//
//  DiscountDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class MoreDiscountViewController: UIViewController {
    
    var discountDetails: [DiscountDetail] = []

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        collectionView.agRegisterCellWithNib(
            identifier: String(describing: DiscountCollectionViewCell.self),
            bundle: nil)
        
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setNavBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_Heart_Selected),
            style: .plain,
            target: self,
            action: #selector(showLikeList))
    }
    
    @objc private func showLikeList() {
        
        //        if let filterVC = UIStoryboard(
        //            name: StoryboardCategory.filter,
        //            bundle: nil).instantiateViewController(
        //                withIdentifier: String(describing: FilterViewController.self)) as? FilterViewController {
        //            let navVC = UINavigationController(rootViewController: filterVC)
        //
        //            self.present(navVC, animated: true, completion: nil)
        //        }
    }

}

extension MoreDiscountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            return CGSize(width: UIScreen.width, height: 300.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 15)
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

extension MoreDiscountViewController: UICollectionViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 350
    }
}

extension MoreDiscountViewController: UICollectionViewDataSource {
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
