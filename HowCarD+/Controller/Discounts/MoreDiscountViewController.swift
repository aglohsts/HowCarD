//
//  DiscountDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class MoreDiscountViewController: HCBaseViewController {
    
    var discountCategoryId: String = ""
    
    var discountObject: DiscountObject? {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
    }
    
    let discountProvider = DiscountProvider()
    
    private struct Segue {
        
        static let discountDetail = "DetailFromMoreDiscountVC"
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        getDiscountByCategory()
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

extension MoreDiscountViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.discountDetail {
            
            guard let discountDetailVC = segue.destination as? DiscountDetailViewController,
                let discountObject = discountObject,
                let selectedPath = sender as? IndexPath
                else {
                    return
            }
            
            discountDetailVC.discountId = discountObject.discountInfos[selectedPath.row].discountId
        }
    }
    
    func getDiscountByCategory() {
        
        discountProvider.getByCategory(id: discountCategoryId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let discountObject):
                
                print(discountObject)
                
                self?.discountObject = discountObject
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
}

extension MoreDiscountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            return CGSize(width: UIScreen.width - 30, height: 280.0)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: Segue.discountDetail, sender: indexPath)
    }
    
}

extension MoreDiscountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let discountObject = discountObject else { return 0 }
        
        return discountObject.discountInfos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DiscountCollectionViewCell.self),
            for: indexPath
        )
        
//        return cell
        
        guard let discountCell = cell as? DiscountCollectionViewCell,
            let discountObject = discountObject
            else { return cell }
        
        discountCell.layoutCell(
            image: discountObject.discountInfos[indexPath.row].image,
            discountTitle: discountObject.discountInfos[indexPath.row].title,
            bankName: discountObject.discountInfos[indexPath.row].bankName,
            cardName: discountObject.discountInfos[indexPath.row].cardName,
            timePeriod: discountObject.discountInfos[indexPath.row].timePeriod,
            isLiked: false
        )

        discountCell.touchHandler = {

//            self.discountDetails[indexPath.row].isLiked = !self.discountDetails[indexPath.row].isLiked
        }

        return discountCell
    }
    
}
