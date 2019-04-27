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

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    var likedDiscountIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
}

extension LikedDiscountViewController {
    
    func getData() {
        
        getDiscountInfo()
        getUserLikedDiscountId()
        
        group.notify(queue: .main, execute: {
            
            // 拿到資料後要比對user收藏的discountID和物件，畫面顯示有收藏的
            })
    }
    
    func getDiscountInfo() {
        
        // TODO: 打api拿所有discount
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
        
        // TODO: Layout cell
        
        return likedDiscountCell
    }
}
