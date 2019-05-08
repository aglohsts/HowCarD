//
//  DiscountsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountsViewController: HCBaseViewController {
    
    let discountProvider = DiscountProvider()
    
    private struct Segue {
        
        static let moreDiscount = "MoreDiscount"
        
        static let discountDetail = "DetailFromDiscountVC"
    }
    
    let group = DispatchGroup()
    
    var userLikedDiscountIds: [String] = []
    
    var userReadDiscountIds: [String] = []
    
    var discountObjects: [DiscountObject] = []
    
    var isFiltered: Bool = false

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setNavBar()
        
        setBackgroundColor()
        
        setTableView()
        
        getData()
        
        discountAddObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        tableView.backgroundColor = .hexStringToUIColor(hex: hex)
    }

    private func setTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setNavBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_Heart_Selected),
            style: .plain,
            target: self,
            action: #selector(showLikeList))
    }
    
    @objc private func showLikeList() {
        
        if let discountLikedListVC = UIStoryboard(
            name: StoryboardCategory.discounts,
            bundle: nil
            ).instantiateViewController(withIdentifier: String(describing: DiscountLikedListViewController.self)
            ) as? DiscountLikedListViewController {
            
            let navVC = UINavigationController(rootViewController: discountLikedListVC)

            self.present(navVC, animated: true, completion: nil)
        }
    }
}

extension DiscountsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.moreDiscount {
            
            guard let moreDiscountVC = segue.destination as? MoreDiscountViewController,
                let datas = sender as? (IndexPath, [String])
                
            else {
                return
            }
            
            moreDiscountVC.discountCategoryId = discountObjects[datas.0.section].categoryId
            
//            moreDiscountVC.ids = datas.1
            
        } else if segue.identifier == Segue.discountDetail {
            
            guard let discountDetailVC = segue.destination as? DiscountDetailViewController,
                let selectedPath = sender as? IndexPath
                
            else {
                return
            }
            
            discountDetailVC.discountId = discountObjects[selectedPath.section]
                .discountInfos[selectedPath.row]
                .discountId
        }
    }
    
    func markDiscountAsRead(indexPath: IndexPath) {
        
        discountObjects[indexPath.section]
            .discountInfos[indexPath.row].isRead = true
        
        // 先檢查有無重複
        if userReadDiscountIds.contains(discountObjects[indexPath.section]
            .discountInfos[indexPath.row].discountId) {
            
            return
        } else {
            userReadDiscountIds.append(discountObjects[indexPath.section]
                .discountInfos[indexPath.row].discountId)
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
            
            HCFirebaseManager.shared.addId(
                userCollection: .isReadDiscounts,
                uid: user.uid,
                id: discountObjects[indexPath.section]
                    .discountInfos[indexPath.row].discountId
            )
        }
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: NotificationNames.updateReadDiscount.rawValue),
            object: nil
        )
    }
    
    func getData() {
        
        getAllDiscount()
        getUserLikedDiscountId()
        getUserReadDiscountId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            self?.checkLikedDiscount()
            
            self?.checkReadDiscount()
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
            }
        })
    }
    
    private func getAllDiscount() {
        
        group.enter()
        
        discountProvider.getCards(completion: { [weak self] result in
            
            switch result {
                
            case .success(let discountObjects):
                
                self?.discountObjects = discountObjects
                
            case .failure(let error):
                
                print(error)
            }
            
            self?.group.leave()
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
    
    @objc func updateLikedDiscount() {
        
        checkLikedDiscount()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
    
    @objc func updateReadDiscount() {
        
        checkReadDiscount()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
    
    func checkLikedDiscount() {
        
        self.userLikedDiscountIds = HCFirebaseManager.shared.likedDiscountIds
        
        for index1 in 0 ..< discountObjects.count {
            
            for index2 in 0 ..< discountObjects[index1].discountInfos.count {
                
                discountObjects[index1].discountInfos[index2].isLiked = false
                
                userLikedDiscountIds.forEach({ (id) in
                    
                    if discountObjects[index1].discountInfos[index2].discountId == id {
                        
                        discountObjects[index1].discountInfos[index2].isLiked = true
                    }
                })
            }
            
        }
    }
    
    func checkReadDiscount() {
        
        self.userReadDiscountIds = HCFirebaseManager.shared.isReadDiscountIds
        
        for index1 in 0 ..< discountObjects.count {
            
            for index2 in 0 ..< discountObjects[index1].discountInfos.count {
                
                discountObjects[index1].discountInfos[index2].isRead = false
                
                userReadDiscountIds.forEach({ (id) in
                    
                    if discountObjects[index1].discountInfos[index2].discountId == id {
                        
                        discountObjects[index1].discountInfos[index2].isRead = true
                    }
                })
            }
        }
    }
}

extension DiscountsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

extension DiscountsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return discountObjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DiscountsTableViewCell.self),
            for: indexPath
        )
        
        guard let discountTableViewCell = cell as? DiscountsTableViewCell else { return cell }

        discountTableViewCell.layoutTableViewCell(
            category: discountObjects[indexPath.section].category,
            discountInfos: discountObjects[indexPath.section].discountInfos
        )
        
        discountTableViewCell.toMoreDiscountHandler = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            let ids: [String] = strongSelf.discountObjects[indexPath.section].discountInfos.compactMap({ info in
                
                if info.isLiked == true {
                    
                    return info.discountId
                }
                
                return nil
            })
            
            strongSelf.performSegue(
                withIdentifier: Segue.moreDiscount,
                sender: (
                    indexPath,
                    ids
                )
            )
        }
        
        discountTableViewCell.toDiscountDetailHandler = { [weak self] (indexPath) in
            
            self?.performSegue(withIdentifier: Segue.discountDetail, sender: indexPath)
        }
        
        discountTableViewCell.isReadTouchHandler = {  (indexPath) in
 
            self.markDiscountAsRead(indexPath: indexPath)
        }
        
        discountTableViewCell.presentAuthVCHandler = { [weak self] in
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                let navVC = UINavigationController(rootViewController: authVC)
                
                self?.present(navVC, animated: true, completion: nil)
            }
        }
        
//        discountTableViewCell.likeButtonDidTouchHandler = { [weak self] (object, cell) in
//
//            guard let strongSelf = self else { return }
        
//            guard let indexPath = strongSelf.tableView.indexPath(for: cell) else { return }
//
//            let datas: [DiscountInfo] = strongSelf.discountObjects[indexPath.section].discountInfos.map({ item in
//
//                if item.discountId == object.discountId {
//                    return object
//                }
//
//                return item
//            })
            
            
            
//            strongSelf.discountObjects[indexPath.section].discountInfos = datas
            
            /// 反向物件的 isLiked
//            strongSelf.discountObjects[indexPath.section].discountInfos[indexPath.row].isLiked =
//                !strongSelf.discountObjects[indexPath.section].discountInfos[indexPath.row].isLiked
//
//            if strongSelf.discountObjects[indexPath.section].discountInfos[indexPath.row].isLiked {
//
//                HCFirebaseManager.shared.deleteId(
//                    userCollection: .likedDiscounts,
//                    uid: user.uid,
//                    id: strongSelf.discountObjects[indexPath.section]
//                        .discountInfos[indexPath.row].discountId
//                )
//            } else {
//
//                HCFirebaseManager.shared.addId(
//                    userCollection: .likedDiscounts,
//                    uid: user.uid,
//                    id: strongSelf.discountObjects[indexPath.section]
//                        .discountInfos[indexPath.row].discountId
//                )
//            }
        
//
            
            
//        }
        
        return discountTableViewCell
    }

}
