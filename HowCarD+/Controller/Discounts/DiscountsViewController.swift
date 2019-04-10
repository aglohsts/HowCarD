//
//  DiscountsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

struct DiscountDetail {
    
    let image: UIImage
    
    let name: String
    
    let target: String
    
    let timePeriod: Int
    
    var isLiked: Bool
}

struct DiscountInfo {
    
    let category: String
    
    let discountDetails: [DiscountDetail]
}

class DiscountsViewController: HCBaseViewController {
    
    private struct Segue {
        
        static let moreDiscount = "MoreDiscount"
    }
    
    var discountInfos: [DiscountInfo] = [
        DiscountInfo(
            category: "銀行",
            discountDetails: [
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1577750400,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false)
            ]),
        
        DiscountInfo(
            category: "回饋",
            discountDetails: [
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false)
            ]
        ),
        
        DiscountInfo(
            category: "外幣消費",
            discountDetails: [
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
                    image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
                    name: "123456789012345678901234567890",
                    target: "OO銀行 XX卡",
                    timePeriod: 1575072000,
                    isLiked: false),
                DiscountDetail(
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

extension DiscountsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.moreDiscount {
            
            guard let moreDiscountVC = segue.destination as? MoreDiscountViewController, let selectedPath = tableView.indexPathForSelectedRow else { return }
            
            moreDiscountVC.discountDetails = self.discountInfos[selectedPath.row].discountDetails
        }
    }
}

extension DiscountsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 350
    }
}

extension DiscountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return discountInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DiscountsTableViewCell.self),
            for: indexPath
        )
        
        guard let discountTableViewCell = cell as? DiscountsTableViewCell else { return cell }
        
        discountTableViewCell.categoryLabel.text = discountInfos[indexPath.row].category
        
        discountTableViewCell.discountDetails = discountInfos[indexPath.row].discountDetails
        
        discountTableViewCell.toMoreDiscountHandler = {
            self.performSegue(withIdentifier: Segue.moreDiscount, sender: nil)
            
        }
        
        return discountTableViewCell
    }
    
}
