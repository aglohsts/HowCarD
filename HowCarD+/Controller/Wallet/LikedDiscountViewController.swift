//
//  LikedDiscountsViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class LikedDiscountViewController: HCBaseViewController {
    
    let group = DispatchGroup()
    
    let discountProvider = DiscountProvider()

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        
        didSet {
            
            searchBar.delegate = self
        }
    }
    
    var isSearching = false
    
    var discountObjects: [DiscountObject] = []
    
    var userLikedDiscounts: [DiscountInfo] = []
    
    var searchResult: [DiscountInfo] = []  {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        setupTableView()
        
        getData()
        
        discountAddObserver()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        tableView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
}

extension LikedDiscountViewController {
    
    func getData() {
        
        getDiscountInfo()
        getUserLikedDiscountId()
        
        group.notify(queue: .main, execute: {
            
            HCFirebaseManager.shared.likedDiscountIds.forEach({ (id) in
                
                for index1 in 0 ..< self.discountObjects.count {
                    
                    for index2 in 0 ..< self.discountObjects[index1].discountInfos.count {
                        
                        if self.discountObjects[index1].discountInfos[index2].discountId == id {
                            
                            let result = self.userLikedDiscounts.firstIndex(where: { (info) -> Bool in
                                
                                if info.discountId == id {
                                    
                                    return true
                                    
                                } else {
                                    
                                    return false
                                }
                            })
                            
                            if result != nil {
                                
                                continue
                                
                            } else {
                                /// isLiked == true 的物件 append 進 userLikedDiscounts
                                self.userLikedDiscounts.append(self.discountObjects[index1].discountInfos[index2])
                            }
                        }
                    }
                }
            })
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
            }
        })
    }
    
    func getDiscountInfo() {
        
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
    
    func getUserLikedDiscountId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .likedDiscounts, completion: { [weak self] ids in
            
            self?.group.leave()
        })
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    func discountAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateLikedDiscount),
                name: NSNotification.Name(NotificationNames.updateLikedDiscount.rawValue),
                object: nil
        )
    }
    
    @objc func updateLikedDiscount() {
        
        /// 先清空 userLikedDiscounts 再比
        self.userLikedDiscounts = []
        
        /// 比對 id 有哪些 isLike == true，true 的話改物件狀態
        HCFirebaseManager.shared.likedDiscountIds.forEach({ (id) in
            
            for index1 in 0 ..< self.discountObjects.count {
                
                for index2 in 0 ..< self.discountObjects[index1].discountInfos.count {
                    
                    if self.discountObjects[index1].discountInfos[index2].discountId == id {
                        
                        let result = self.userLikedDiscounts.firstIndex(where: { (info) -> Bool in
                            
                            if info.discountId == id {
                                
                                return true
                            } else {
                                
                                return false
                            }
                        })
                        
                        if result != nil {
                            
                            continue
                            
                        } else {
                            /// isLiked == true 的物件 append 進 userLikedDiscounts
                            self.userLikedDiscounts.append(self.discountObjects[index1].discountInfos[index2])
                        }
                    }
                }
            }
        })
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
        }
    }
}

extension LikedDiscountViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            isSearching = false
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
            }
        } else {
            
            searchResult = userLikedDiscounts.filter({
                
                $0.bankName.contains(searchText) ||
                $0.cardName.uppercased().contains(searchText.uppercased()) ||
                $0.cardName.lowercased().contains(searchText.lowercased()) ||
                $0.title.uppercased().contains(searchText.uppercased()) ||
                $0.title.contains(searchText) ||
                $0.title.lowercased().contains(searchText.lowercased()) ||
                
                $0.timePeriod.contains(searchText)
            })
            
            isSearching = true
        }
    }
}


extension LikedDiscountViewController: UITableViewDelegate {
    
}

extension LikedDiscountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return searchResult.count
        } else {
            
            return userLikedDiscounts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LikedDiscountTableViewCell.self),
            for: indexPath
        )
        
        guard let likedDiscountCell = cell as? LikedDiscountTableViewCell else { return cell }
        
        if isSearching {
            
            likedDiscountCell.layoutCell(
                discountTitle: self.searchResult[indexPath.row].title,
                bankName: self.searchResult[indexPath.row].bankName,
                cardName: self.searchResult[indexPath.row].cardName,
                timePeriod: self.searchResult[indexPath.row].timePeriod,
                discountImage: self.searchResult[indexPath.row].image
            )
        } else {
            
            likedDiscountCell.layoutCell(
                discountTitle: self.userLikedDiscounts[indexPath.row].title,
                bankName: self.userLikedDiscounts[indexPath.row].bankName,
                cardName: self.userLikedDiscounts[indexPath.row].cardName,
                timePeriod: self.userLikedDiscounts[indexPath.row].timePeriod,
                discountImage: self.userLikedDiscounts[indexPath.row].image
            )
        }
        
        likedDiscountCell.deleteDidTouchHandler = { [weak self] in
            
            guard let strongSelf = self,
                let user = HCFirebaseManager.shared.agAuth().currentUser else {
                    return
            }
            
//            strongSelf.userLikedDiscounts.remove(at: indexPath.row)
            
            if strongSelf.isSearching {

                HCFirebaseManager.shared.deleteId(
                    viewController: strongSelf,
                    userCollection: .likedDiscounts,
                    uid: user.uid,
                    id: strongSelf.searchResult[indexPath.row].discountId,
                    loadingAnimation: strongSelf.startLoadingAnimation(viewController:)
                )
                
//                strongSelf.searchResult.remove(at: indexPath.row)
            } else {

                HCFirebaseManager.shared.deleteId(
                    viewController: strongSelf,
                    userCollection: .likedDiscounts,
                    uid: user.uid,
                    id: strongSelf.userLikedDiscounts[indexPath.row].discountId,
                    loadingAnimation: strongSelf.startLoadingAnimation(viewController:)
                )
                
//                strongSelf.userLikedDiscounts.remove(at: indexPath.row)
            }
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: NotificationNames.updateLikedDiscount.rawValue),
                object: nil
            )
        }
        
        return likedDiscountCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
}
