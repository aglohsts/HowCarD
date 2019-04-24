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
    
    var discountObjects: [DiscountObject] = [] {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
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
        
        setTableView()
        
        getAllDiscount()
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
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: DiscountLikedListViewController.self)) as? DiscountLikedListViewController {
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
            
            moreDiscountVC.ids = datas.1
            
        } else if segue.identifier == Segue.discountDetail {
            
            guard let discountDetailVC = segue.destination as? DiscountDetailViewController,
                let selectedPath = sender as? IndexPath
                
            else {
                return
            }
            
            discountDetailVC.discountId = discountObjects[selectedPath.section].discountInfos[selectedPath.row].discountId

        }
    }
    
    func getAllDiscount() {
        
        discountProvider.getCards(completion: { [weak self] result in
            
            switch result {
                
            case .success(let discountObjects):
                
                print(discountObjects)
                
                self?.discountObjects = discountObjects
                
            case .failure(let error):
                
                print(error)
            }
        })
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
        
        discountTableViewCell.likeButtonDidTouchHandler = { [weak self] (object, cell) in
            
            guard let strongSelf = self else { return }
            
            guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
            
            let datas: [DiscountInfo] = strongSelf.discountObjects[indexPath.section].discountInfos.map({ item in
                
                if item.discountId == object.discountId {
                    return object
                }
                
                return item
            })
            
            strongSelf.discountObjects[indexPath.section].discountInfos = datas
            
        }
        
        return discountTableViewCell
    }
    
}
