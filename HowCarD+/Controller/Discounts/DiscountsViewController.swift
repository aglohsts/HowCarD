//
//  DiscountsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

struct DiscountDetailDelete {
    
    let image: UIImage
    
    let name: String
    
    let target: String
    
    let timePeriod: Int
    
    var isLiked: Bool
}

struct DiscountInfoDelete {
    
    let category: String
    
    let discountDetails: [DiscountDetailDelete]
}

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
    
    var discountInfos: [DiscountInfoDelete] = [
        DiscountInfoDelete(
            category: "銀行",
            discountDetails: [
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1577750400,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false)
            ]),
        
        DiscountInfoDelete(
            category: "回饋",
            discountDetails: [
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false)
            ]
        ),
        
        DiscountInfoDelete(
            category: "外幣消費",
            discountDetails: [
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetailDelete(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false)
            ]
        )
    ]
    
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
                let selectedPath = sender as? IndexPath
                
            else {
                return
            }
            
            moreDiscountVC.discountDetails = self.discountInfos[selectedPath.row].discountDetails
            
            moreDiscountVC.discountCategoryId = discountObjects[selectedPath.section].categoryId
            
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
        
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

extension DiscountsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return discountObjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return discountObjects[section].discountInfos.count
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
        
        discountTableViewCell.toMoreDiscountHandler = {
            
            self.performSegue(withIdentifier: Segue.moreDiscount, sender: indexPath)
            
        }
        
        discountTableViewCell.toDiscountDetailHandler = {
            
            self.performSegue(withIdentifier: Segue.discountDetail, sender: nil)
        }
        
        return discountTableViewCell
    }
    
}
