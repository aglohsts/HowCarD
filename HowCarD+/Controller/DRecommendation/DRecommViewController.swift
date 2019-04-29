//
//  DRecommViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FoldingCell
import Crashlytics

class DRecommViewController: HCBaseViewController {
    
    private struct Segue {
        
        static let cardDetail = "toCardDetail"
        
        static let discountDetail = "toDiscountDetail"
        
        static let topVC = "DRecommTopVC"
    }
    
    // swiftlint:disable force_cast
    
    let dRecommCategoryDetailVC = UIStoryboard(
        name: StoryboardCategory.dRecommend,
        bundle: nil).instantiateViewController(
            withIdentifier: String(describing: DRecommCategoryDetailViewController.self))
        as! DRecommCategoryDetailViewController
    
    // swiftlint:enable force_cast
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newCards = [CardBasicInfoObject]()
    
    var selectedCards = [CardBasicInfoObject]()
    
    var newDiscounts = [DiscountDetail]()
    
    var selectedDiscounts = [DiscountDetail]()
    
    let group = DispatchGroup()
    
    var dRecommArray: [[Collapsable]] = []
    
    let titleArray = ["最新卡片", "最新優惠", "精選卡片", "精選優惠"]
    
    let dRecommProvider = DRecommProvider()
    
    enum Const {
        static let closeCellHeight: CGFloat = 135
        static let openCellHeight: CGFloat = 280
        static let rowsCount = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        getData()
    }
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: HCTableViewSectionHeaderView.self),
            bundle: nil
        )
        
        setBackgroundColor(.viewBackground)
        
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = Const.closeCellHeight
        
        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    override func setBackgroundColor(_ hex: HCColorHex) {
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
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

extension DRecommViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.cardDetail {
            
            guard let cardDetailVC = segue.destination as? CardDetailViewController,
                let selectedPath = sender as? IndexPath
                
                else {
                    return
            }
            
            let dRecommData = dRecommArray[selectedPath.section][selectedPath.row] as? CardBasicInfoObject
            
            guard let card = dRecommData else { return }
            
            cardDetailVC.cardID = card.id
            
        } else if segue.identifier == Segue.discountDetail {

            guard let discountDetailVC = segue.destination as? DiscountDetailViewController,
                let selectedPath = sender as? IndexPath else {
                    return
            }
            
            let dRecommData = dRecommArray[selectedPath.section][selectedPath.row] as? DiscountDetail
            
            guard let discount = dRecommData else { return }
            
            discountDetailVC.discountId = discount.info.discountId
            
        } else if segue.identifier == Segue.topVC {
            
            guard let dRecommTopVC = segue.destination as? DRecommTopViewController else { return }
            
            dRecommTopVC.touchHandler = {
                
                if self.dRecommCategoryDetailVC.view.superview == nil {
                    
                    self.addChild(self.dRecommCategoryDetailVC)
                    
                    let toContainerLeftBottom = self.containerView.frame.origin.y + self.containerView.frame.height
                    
                    self.dRecommCategoryDetailVC.view.frame = CGRect(
                        x: 0, y: toContainerLeftBottom,
                        width: UIScreen.main.bounds.width,
                        height: self.tableView.frame.height
                    )
                
                    self.view.addSubview(self.dRecommCategoryDetailVC.view)
                    
                    self.dRecommCategoryDetailVC.didMove(toParent: self)
                }
            }
        }
    }
}

// MARK: - TableView

extension DRecommViewController: UITableViewDelegate {
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as DRecommTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .white
        
        if dRecommArray[indexPath.section][indexPath.row].cellHeight == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //        cell.number = indexPath.row
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dRecommArray[indexPath.section][indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DRecommTableViewCell else {
            
            return
        }
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = dRecommArray[indexPath.section][indexPath.row].cellHeight == Const.closeCellHeight
        
        if cellIsCollapsed {
            dRecommArray[indexPath.section][indexPath.row].cellHeight = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            dRecommArray[indexPath.section][indexPath.row].cellHeight = Const.closeCellHeight
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
            withIdentifier: String(describing: HCTableViewSectionHeaderView.self)
        )
        
        guard let headerView = view as? HCTableViewSectionHeaderView else { return view }
        
        headerView.layoutView(contentTitle: titleArray[section])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? HCTableViewSectionHeaderView else { return }
        
        headerView.contentView.backgroundColor = .hexStringToUIColor(hex: .viewBackground)
    }
}

extension DRecommViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dRecommArray.count
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

//        let cellIsCollapsed = cellHeights[indexPath.section][indexPath.row] == Const.closeCellHeight
//
//        if cellIsCollapsed {
//            cell.unfold(true, animated: false, completion: nil)
//        } else {
//            cell.unfold(false, animated: false, completion: nil)
//        }
        
        switch indexPath.section {
        case 0, 2:
            
            let dRecommData = dRecommArray[indexPath.section][indexPath.row] as? CardBasicInfoObject
            
            guard let card = dRecommData else { return UITableViewCell() }
            
            cell.layoutCell(
                image: card.image,
                title: card.name,
                target: card.bank,
                timePeriod: nil,
                note: card.note
            )
            
            cell.layoutCollectionView(briefIntroArray: card.briefIntro, tagArray: card.tags)
            
            cell.toDetailHandler = {
                self.performSegue(withIdentifier: Segue.cardDetail, sender: indexPath)
            }
            
        case 1, 3:
            
            let dRecommData = dRecommArray[indexPath.section][indexPath.row] as? DiscountDetail
            
            guard let discount = dRecommData else { return UITableViewCell() }
            
            cell.layoutCell(
                image: discount.info.image,
                title: discount.info.title,
                target: "\(discount.info.bankName) \(discount.info.cardName)",
                timePeriod: discount.info.timePeriod,
                note: discount.note
            )
            
            cell.layoutCollectionView(briefIntroArray: discount.briefIntro, tagArray: nil)
            
            cell.toDetailHandler = {
                self.performSegue(withIdentifier: Segue.discountDetail, sender: indexPath)
            }
            
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
            
            guard let strongSelf = self else { return }
            
            self?.dRecommArray = [strongSelf.newCards, strongSelf.newDiscounts, strongSelf.selectedCards, strongSelf.selectedDiscounts]
            
            self?.tableView.reloadData()
        })
    }
    
    func getNewCards() {
        
        group.enter()
        
        dRecommProvider.getNewCards(completion: { [weak self] result in
            
            switch result {
            
            case .success(let newCards):
                
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
