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
    
    var userLikedDiscountIds: [String] = []
    
    var userReadDiscountIds: [String] = []
    
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
        
        checkLikedDiscount()
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    
    @objc func updateReadDiscount() {
        
        checkReadDiscount()
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    
    func checkLikedDiscount() {
        
        userLikedDiscountIds = HCFirebaseManager.shared.likedDiscountIds
        
        /// 比對 id 有哪些 isLike == true，true 的話改物件狀態
        for index in 0 ..< discountObject!.discountInfos.count {
            
            // all false
            if discountObject!.discountInfos[index].isRead != false {
                
                discountObject!.discountInfos[index].isLiked = false
            }
            // check if true
            userLikedDiscountIds.forEach({ (id) in
                
                if discountObject!.discountInfos[index].discountId == id {
                    
                    discountObject!.discountInfos[index].isLiked = true
                }
            })
        }
    }
    
    func checkReadDiscount() {
        
        userReadDiscountIds = HCFirebaseManager.shared.isReadDiscountIds
        
        /// 比對 id 有哪些 isRead == true，true 的話改物件狀態
        for index in 0 ..< discountObject!.discountInfos.count {
            
            // all false
            if discountObject!.discountInfos[index].isRead != false {
                
                discountObject!.discountInfos[index].isRead = false
            }
            // check if true
            userReadDiscountIds.forEach({ (id) in
                
                if discountObject!.discountInfos[index].discountId == id {
                    
                    discountObject!.discountInfos[index].isRead = true
                }
            })
        }
    }
    
    func markDiscountAsRead(indexPath: IndexPath) {
        
        if discountObject != nil {
            
            discountObject!.discountInfos[indexPath.item].isRead = true
            
            if userReadDiscountIds.contains(discountObject!.discountInfos[indexPath.item].discountId) {
                
                return
            } else {
                userReadDiscountIds.append(discountObject!.discountInfos[indexPath.item].discountId)
                
                guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                
                HCFirebaseManager.shared.addId(
                    userCollection: .isReadDiscounts,
                    uid: user.uid,
                    id: discountObject!.discountInfos[indexPath.item].discountId
                )
            }
        }
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: NotificationNames.updateReadDiscount.rawValue),
            object: nil
        )
    }
    
    func discountAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateLikedDiscount),
                name: NSNotification.Name(NotificationNames.updateLikedDiscount.rawValue),
                object: nil
        )
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateReadDiscount),
                name: NSNotification.Name(NotificationNames.updateReadDiscount.rawValue),
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
        getUserReadDiscountId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            if self?.discountObject != nil {
                
                self?.checkLikedDiscount()
                self?.checkReadDiscount()
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
    }
    
    private func getDiscountByCategory() {
        
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
    
    private func getUserLikedDiscountId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .likedDiscounts, completion: { [weak self] ids in
            
            self?.userLikedDiscountIds = ids
            
            self?.group.leave()
        })
    }
    
    private func getUserReadDiscountId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .isReadDiscounts, completion: { [weak self] ids in
            
            self?.userReadDiscountIds = ids
            
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
        
        // isRead
        markDiscountAsRead(indexPath: indexPath)
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
            isLiked: self.discountObject?.discountInfos[indexPath.item].isLiked ?? false,
            isRead: self.discountObject?.discountInfos[indexPath.item].isRead ?? false
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
                    name: Notification.Name(rawValue: NotificationNames.updateLikedDiscount.rawValue),
                    object: nil
                )
            }
        return discountCollectionViewCell
    }

}
