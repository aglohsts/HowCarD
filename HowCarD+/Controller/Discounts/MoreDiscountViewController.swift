//
//  DiscountDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class MoreDiscountViewController: HCBaseViewController {
    
    let group = DispatchGroup()
    
    var discountCategoryId: String = ""
    
    var likedDiscountIds: [String] = []
    
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
        
        getData()
        
        discountAddObserver()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        collectionView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
    
    private func setupCollectionView() {
        
        collectionView.agRegisterCellWithNib(
            identifier: String(describing: DiscountCollectionViewCell.self),
            bundle: nil)
        
        collectionView.showsVerticalScrollIndicator = false
        
        setBackgroundColor()
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
    
    @objc func updateLikedDiscount() {
        
        likedDiscountIds = HCFirebaseManager.shared.likedDiscountIds
        
        /// 比對 id 有哪些 isLike == true，true 的話改物件狀態
        for index in 0 ..< discountObject!.discountInfos.count {
                
                discountObject!.discountInfos[index].isLiked = false
                
                likedDiscountIds.forEach({ (id) in
                    
                    if discountObject!.discountInfos[index].discountId == id {
                        
                        discountObject!.discountInfos[index].isLiked = true
                    }
                })
        }
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    
    func discountAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateLikedDiscount),
                name: NSNotification.Name(NotificationNames.discountLikeButtonTapped.rawValue),
                object: nil
        )
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
    
    func getData() {
        
        getDiscountByCategory()
        getUserLikedDiscountId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.discountObject != nil {
                
                strongSelf.likedDiscountIds.forEach({ (id) in
                    
                    for index in 0 ..< strongSelf.discountObject!.discountInfos.count {
                        
                        if strongSelf.discountObject!.discountInfos[index].discountId == id {
                            
                            strongSelf.discountObject!.discountInfos[index].isLiked = true
                        }
                    }
                })
            }
            
            DispatchQueue.main.async {
                strongSelf.collectionView.reloadData()
            }
        })
    }
    
    func getDiscountByCategory() {
        
        group.enter()
        
        discountProvider.getByCategory(id: discountCategoryId, completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let discountObject):
                
                print(discountObject)
                
                strongSelf.discountObject = discountObject

            case .failure(let error):
                
                print(error)
            }
            
            strongSelf.group.leave()
        })
    }
    
    func getUserLikedDiscountId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .likedDiscounts, completion: { [weak self] ids in
            
            self?.likedDiscountIds = ids
            
            self?.group.leave()
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
        
        guard let discountCollectionViewCell = cell as? DiscountCollectionViewCell
            else { return cell }
        
//        let flag = ids.contains(discountObject.discountInfos[indexPath.row].discountId)
        
        discountCollectionViewCell.layoutCell(
            image: self.discountObject?.discountInfos[indexPath.item].image ?? "",
            discountTitle: self.discountObject?.discountInfos[indexPath.item].title ?? "",
            bankName: self.discountObject?.discountInfos[indexPath.item].bankName ?? "",
            cardName: self.discountObject?.discountInfos[indexPath.item].cardName ?? "",
            timePeriod: self.discountObject?.discountInfos[indexPath.item].timePeriod ?? "",
            isLiked: self.discountObject?.discountInfos[indexPath.item].isLiked ?? false
        )

        discountCollectionViewCell.likeBtnTouchHandler = { [weak self] in

            guard let strongSelf = self, let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
            
                if strongSelf.discountObject!.discountInfos[indexPath.item].isLiked {
                    
                    HCFirebaseManager.shared.deleteId(
                        userCollection: .likedDiscounts,
                        uid: user.uid,
                        id: strongSelf.discountObject!.discountInfos[indexPath.item].discountId
                    )
                } else {
                    
                    HCFirebaseManager.shared.addId(
                        userCollection: .likedDiscounts,
                        uid: user.uid,
                        id: strongSelf.discountObject!.discountInfos[indexPath.item].discountId
                    )
                }
            strongSelf.discountObject!.discountInfos[indexPath.row].isLiked =
                !strongSelf.discountObject!.discountInfos[indexPath.row].isLiked

                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: NotificationNames.discountLikeButtonTapped.rawValue),
                    object: nil
                )
            }
        return discountCollectionViewCell
    }

}
