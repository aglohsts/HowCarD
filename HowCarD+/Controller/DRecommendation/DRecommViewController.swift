//
//  DRecommViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FoldingCell

class DRecommViewController: HCBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newCards = [CardBasicInfoObject]()
    
    var selectedCards = [CardBasicInfoObject]()
    
    var newDiscounts = [DiscountDetail]()
    
    var selectedDiscounts = [DiscountDetail]()
    
    let group = DispatchGroup()
    
    var dRecommArray: [[Any]] {
        return [newCards, newDiscounts, selectedCards, selectedDiscounts]
    }
    
    let titleArray = ["最新卡片", "最新優惠", "精選卡片", "精選優惠"]
    
    let dRecommProvider = DRecommProvider()
    
    enum Const {
        static let closeCellHeight: CGFloat = 135
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        getData()
    }
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: DRecommSectionHeaderView.self),
            bundle: nil
        )
        
        tableView.separatorStyle = .none
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension DRecommViewController: UITableViewDelegate {
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DRecommTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //        cell.number = indexPath.row
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DRecommTableViewCell else {
            
            return
        }
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DRecommSectionHeaderView.self)
        )
        
        guard let headerView = view as? DRecommSectionHeaderView else { return view }
        
        headerView.layoutView(category: titleArray[section])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? DRecommSectionHeaderView else { return }
        
        headerView.contentView.backgroundColor = UIColor.white
    }
}

extension DRecommViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return titleArray.count
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return dRecommArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DRecommTableViewCell.self),
            for: indexPath) as? DRecommTableViewCell else {
            
            return UITableViewCell()
        }
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        switch indexPath.section {
        case 0, 2:
            
            let dRecommData = dRecommArray[indexPath.section][indexPath.row] as? CardBasicInfoObject
            
            guard let card = dRecommData else { return UITableViewCell() }
            
            cell.layoutCell(
                image: card.image,
                title: card.name,
                target: card.bank
            )
            
        case 1, 3:
            
            let dRecommData = dRecommArray[indexPath.section][indexPath.row] as? DiscountDetail
            
            guard let discount = dRecommData else { return UITableViewCell() }
            
            cell.layoutCell(
                image: discount.info.image,
                title: discount.info.title,
                target: "\(discount.info.bankName) \(discount.info.cardName)"
            )
            
        default: return UITableViewCell()
        }
        
        return cell
    }
    
}

extension DRecommViewController {
    
    func getData() {
        
        getNewCards()
        getNewDiscounts()
        getSelectedCards()
        getSelectedDiscounts()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            self?.tableView.reloadData()
        })
    }
    
    func getNewCards() {
        
        group.enter()
        
        dRecommProvider.getNewCards(completion: { [weak self] result in
            
            switch result {
            
            case .success(let newCards):
            
                print(newCards)
                
                self?.newCards = newCards
            
            case .failure(let error):
            
            print(error)
            }
            
            self?.group.leave()
        })
    }
    
    func getSelectedCards() {
        
        group.enter()
        
        dRecommProvider.getSelectedCards(completion: { [weak self] result in
            
            switch result {
                
            case .success(let selectedCards):
                
                print(selectedCards)
                
                self?.selectedCards = selectedCards
                
            case .failure(let error):
                
                print(error)
            }
            
            self?.group.leave()
        })
    }
    
    func getNewDiscounts() {
        
        group.enter()
        
        dRecommProvider.getNewDiscounts(completion: { [weak self] result in
            
            switch result {
                
            case .success(let newDiscounts):
                
                print(newDiscounts)
                
                self?.newDiscounts = newDiscounts
                
            case .failure(let error):
                
                print(error)
            }
            
            self?.group.leave()
        })
    }
    
    func getSelectedDiscounts() {
        
        group.enter()
        
        dRecommProvider.getSelectedDiscounts(completion: { [weak self] result in
            
            switch result {
                
            case .success(let selectedDiscounts):
                
                print(selectedDiscounts)
                
                self?.selectedDiscounts = selectedDiscounts
                
            case .failure(let error):
                
                print(error)
            }
            
            self?.group.leave()
        })
    }
}
//
//
//
//{
//
//    let categoryArray = ["最新卡片", "精選卡片", "最新優惠", "精選優惠"]
//
//    @IBOutlet weak var tableView: UITableView! {
//        didSet {
//
//            tableView.delegate = self
//
//            tableView.dataSource = self
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTableView()
//    }
//
//    private func setupTableView() {
//        tableView.showsVerticalScrollIndicator = false
//
//        tableView.separatorStyle = .none
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension DRecommViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 153
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//}
//
//extension DRecommViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return categoryArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: String(describing: DRecommTableViewHeaderCell.self),
//            for: indexPath
//        )
//
//        guard let dRecommCell = cell as? DRecommTableViewHeaderCell else { return cell }
//
//        dRecommCell.layoutCell(image: UIImage.asset(.Image_Placeholder)!, title: categoryArray[indexPath.row])
//
//        return dRecommCell
//    }
//
//}
