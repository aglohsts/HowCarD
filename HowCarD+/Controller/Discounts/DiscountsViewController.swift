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
    
    var likedDiscountIds: [String] = []
    
    var discountObjects: [DiscountObject] = [] {
        
        didSet {
            
            DispatchQueue.main.async {
                
//                self.tableView.reloadData()
            }
        }
    }
    
    var isFiltered: Bool = false

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        
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
    
    func getData() {
        
        getAllDiscount()
        getUserLikedDiscountId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.likedDiscountIds.forEach({ (id) in
                
                for index1 in 0 ..< strongSelf.discountObjects.count {
                    
                    for index2 in 0 ..< strongSelf.discountObjects[index1].discountInfos.count {
                        
                        if strongSelf.discountObjects[index1].discountInfos[index2].discountId == id {
                            
                            strongSelf.discountObjects[index1].discountInfos[index2].isLiked = true
                        }
                    }
                }
            })
            
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
            
            self?.likedDiscountIds = ids
            
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
    }
    
    @objc func updateLikedDiscount() {
        
        self.likedDiscountIds = HCFirebaseManager.shared.likedDiscountIds
        
        for index1 in 0 ..< discountObjects.count {
            
            for index2 in 0 ..< discountObjects[index1].discountInfos.count {
                
                discountObjects[index1].discountInfos[index2].isLiked = false
                
                likedDiscountIds.forEach({ (id) in
                    
                    if discountObjects[index1].discountInfos[index2].discountId == id {
                        
                        discountObjects[index1].discountInfos[index2].isLiked = true
                    }
                })
            }
            
        }
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
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
        
        discountTableViewCell.toDiscountDetailHandler = { (indexPath) in
            
            self.performSegue(withIdentifier: Segue.discountDetail, sender: indexPath)
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
