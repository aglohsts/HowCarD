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
    
    var likedDiscountIds: [String] = []
    
    var discountObjects: [DiscountObject] = []
    
    var userLikedDiscounts: [DiscountInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        getData()
        
        discountAddObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension LikedDiscountViewController {
    
    func getData() {
        
        getDiscountInfo()
        getUserLikedDiscountId()
        
        group.notify(queue: .main, execute: {
            
            self.likedDiscountIds.forEach({ (id) in
                
                for index1 in 0 ..< self.discountObjects.count {
                    
                    for index2 in 0 ..< self.discountObjects[index1].discountInfos.count {
                        
                        if self.discountObjects[index1].discountInfos[index2].discountId == id {
                            
                            self.userLikedDiscounts.append(self.discountObjects[index1].discountInfos[index2])
                        }
                    }
                }
            })
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
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
            
            self?.likedDiscountIds = ids
            
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
                selector: #selector(updateCollectedDiscount),
                name: NSNotification.Name(NotificationNames.discountLikeButtonTapped.rawValue),
                object: nil
        )
    }
    
    @objc func updateCollectedDiscount() {
        
        likedDiscountIds = HCFirebaseManager.shared.likedDiscountIds
        
        /// 比對 id 有哪些 isLike == true，true 的話改物件狀態
        self.likedDiscountIds.forEach({ (id) in
            
            for index1 in 0 ..< self.discountObjects.count {
                
                for index2 in 0 ..< self.discountObjects[index1].discountInfos.count {
                    
                    if self.discountObjects[index1].discountInfos[index2].discountId == id {
                        
                        self.userLikedDiscounts.append(self.discountObjects[index1].discountInfos[index2])
                    }
                }
            }
        })
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
}

extension LikedDiscountViewController: UITableViewDelegate {
    
}

extension LikedDiscountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likedDiscountIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LikedDiscountTableViewCell.self),
            for: indexPath
        )
        
        guard let likedDiscountCell = cell as? LikedDiscountTableViewCell else { return cell }
        
        likedDiscountCell.layoutCell(
            discountTitle: self.userLikedDiscounts[indexPath.row].title,
            bankName: self.userLikedDiscounts[indexPath.row].bankName,
            cardName: self.userLikedDiscounts[indexPath.row].cardName,
            timePeriod: self.userLikedDiscounts[indexPath.row].timePeriod,
            discountImage: self.userLikedDiscounts[indexPath.row].image
        )
        
        return likedDiscountCell
    }
}
