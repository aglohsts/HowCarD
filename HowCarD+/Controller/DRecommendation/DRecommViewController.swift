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
    
    private struct Segue {
        
        static let cardDetail = "ToCardDetail"
        
        static let discountDetail = "ToDiscountDetail"
        
        static let topVC = "DRecommTopVC"
    }
    
    private enum DRecommSection: Int {
            
        case newCards = 0
        
        case newDiscounts = 1
        
        case selectedCards = 2
        
        case selectedDiscounts = 3
        
        func title() -> String {
            switch self {
            case .newCards: return "最新卡片"
                
            case .newDiscounts: return "最新優惠"
                
            case .selectedCards: return "精選卡片"
                
            case .selectedDiscounts: return "精選優惠"
            }
        }
    }
    
    let dRecommProvider = DRecommProvider()
    
    // swiftlint:disable force_cast
    
    let dRecommCategoryDetailVC = UIStoryboard(
        name: StoryboardCategory.dRecommend,
        bundle: nil).instantiateViewController(
            withIdentifier: String(describing: DRecommCategoryDetailViewController.self))
        as! DRecommCategoryDetailViewController
    
    // swiftlint:enable force_cast
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newCards: [CardBasicInfoObject] = []
    
    var selectedCards: [CardBasicInfoObject] = []
    
    var newDiscounts: [DiscountDetail] = []
    
    var selectedDiscounts: [DiscountDetail] = []
    
    var userReadCardIds: [String] = []
    
    var userReadDiscountIds: [String] = []
    
    let group = DispatchGroup()
    
    var dRecommArray: [[Collapsable]] = [] 
    
    private let titleArray: [String] = [
        DRecommSection.newCards.title(),
        DRecommSection.newDiscounts.title(),
        DRecommSection.selectedCards.title(),
        DRecommSection.selectedDiscounts.title()
    ]
    
    enum Const {
        static let closeCellHeight: CGFloat = 133
        static let openCellHeight: CGFloat = 257
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        
        setupTableView()
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: HCTableViewSectionHeaderView.self),
            bundle: nil
        )
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.estimatedRowHeight = Const.closeCellHeight
        
        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        
        setBackgroundColor(.viewBackground)
        
        
    }
    
    override func setBackgroundColor(_ hex: HCColorHex) {
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                
                // TODO: 下拉更新
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
            
            dRecommTopVC.touchHandler = { [weak self] id in
                
                guard let strongSelf = self else { return }
                
                strongSelf.getCategoryDiscountInfo(id: id, completionHandler: { [weak self] dRecommSections in
                    
                    self?.dRecommCategoryDetailVC.loadViewIfNeeded()
                    
                    self?.dRecommCategoryDetailVC.dRecommSections = dRecommSections
                })
                
                if strongSelf.dRecommCategoryDetailVC.view.superview == nil {
                    
                    strongSelf.addChild(strongSelf.dRecommCategoryDetailVC)
                    
                    let toContainerLeftBottom =
                        strongSelf.containerView.frame.origin.y + strongSelf.containerView.frame.height
                    
                    strongSelf.dRecommCategoryDetailVC.view.frame = CGRect(
                        x: 0, y: toContainerLeftBottom,
                        width: UIScreen.main.bounds.width,
                        height: strongSelf.tableView.frame.height
                    )
                    
                    strongSelf.view.addSubview(strongSelf.dRecommCategoryDetailVC.view)
                    
                    strongSelf.dRecommCategoryDetailVC.didMove(toParent: strongSelf)
                }
            }
        }
    }
    
    func addObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateReadDiscount),
                name: NSNotification.Name(NotificationNames.updateReadDiscount.rawValue),
                object: nil
        )
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateReadCard),
                name: NSNotification.Name(NotificationNames.updateReadCard.rawValue),
                object: nil
        )
    }
    
    @objc func updateReadDiscount() {
        checkReadDiscount()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func updateReadCard() {
        checkReadCard()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // swiftlint:disable cyclomatic_complexity
    func markAsRead(indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case DRecommSection.newCards.rawValue:
            
            if newCards[indexPath.row].isRead != true {
                
                newCards[indexPath.row].isRead = true
                
                guard var cardBasicInfoObject = dRecommArray[indexPath.section][indexPath.row] as? CardBasicInfoObject else { return }
                
                cardBasicInfoObject.isRead = true
                
                dRecommArray[indexPath.section][indexPath.row] = cardBasicInfoObject
                
                // Firebase
                if userReadCardIds.contains(newCards[indexPath.row].id) {
                    
                    return
                } else {
                    userReadCardIds.append(newCards[indexPath.row].id)
                    
                    guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                    
                    HCFirebaseManager.shared.addId(
                        viewController: self,
                        userCollection: .isReadCards,
                        uid: user.uid,
                        id: newCards[indexPath.row].id,
                        loadingAnimation: self.startLoadingAnimation(viewController:),
                        addIdCompletionHandler: { _ in
                            
                            NotificationCenter.default.post(
                                name: Notification.Name(rawValue: NotificationNames.updateReadCard.rawValue),
                                object: nil
                            )
                    })
                }
            }
            
        case DRecommSection.newDiscounts.rawValue:
            
            if newDiscounts[indexPath.row].info.isRead != true {
                
                newDiscounts[indexPath.row].info.isRead = true
                
                guard var discountDetail = dRecommArray[indexPath.section][indexPath.row] as? DiscountDetail else { return }
                
                discountDetail.info.isRead = true
                
                dRecommArray[indexPath.section][indexPath.row] = discountDetail
                
                // Firebase
                if userReadDiscountIds.contains(newDiscounts[indexPath.row].info.discountId) {
                    
                    return
                } else {
                    userReadCardIds.append(newDiscounts[indexPath.row].info.discountId)
                    
                    guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                    
                    HCFirebaseManager.shared.addId(
                        viewController: self,
                        userCollection: .isReadDiscounts,
                        uid: user.uid,
                        id: newDiscounts[indexPath.row].info.discountId,
                        loadingAnimation: self.startLoadingAnimation(viewController:),
                        addIdCompletionHandler: { _ in
                            
                            NotificationCenter.default.post(
                                name: Notification.Name(rawValue: NotificationNames.updateReadDiscount.rawValue),
                                object: nil
                            )
                    })
                }
                
                
            }
        case DRecommSection.selectedCards.rawValue:
            
            if selectedCards[indexPath.row].isRead != true {
                
                selectedCards[indexPath.row].isRead = true
                
                guard var cardBasicInfoObject = dRecommArray[indexPath.section][indexPath.row] as? CardBasicInfoObject else { return }
                
                cardBasicInfoObject.isRead = true
                
                dRecommArray[indexPath.section][indexPath.row] = cardBasicInfoObject
                
                // Firebase
                if userReadCardIds.contains(selectedCards[indexPath.row].id) {
                    
                    return
                } else {
                    userReadCardIds.append(selectedCards[indexPath.row].id)
                    
                    guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                    
                    HCFirebaseManager.shared.addId(
                        viewController: self,
                        userCollection: .isReadCards,
                        uid: user.uid,
                        id: selectedCards[indexPath.row].id,
                        loadingAnimation: self.startLoadingAnimation(viewController:),
                        addIdCompletionHandler: { _ in
                            
                            NotificationCenter.default.post(
                                name: Notification.Name(rawValue: NotificationNames.updateReadCard.rawValue),
                                object: nil
                            )
                    })
                }
                
                
            }
        case DRecommSection.selectedDiscounts.rawValue:
            
            if selectedDiscounts[indexPath.row].info.isRead != true {
                
                selectedDiscounts[indexPath.row].info.isRead = true
                
                guard var discountDetail = dRecommArray[indexPath.section][indexPath.row] as? DiscountDetail else { return }
                
                discountDetail.info.isRead = true
                
                dRecommArray[indexPath.section][indexPath.row] = discountDetail
                
                // Firebase
                if userReadDiscountIds.contains(selectedDiscounts[indexPath.row].info.discountId) {
                    
                    return
                } else {
                    userReadCardIds.append(selectedDiscounts[indexPath.row].info.discountId)
                    
                    guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                    
                    HCFirebaseManager.shared.addId(
                        viewController: self,
                        userCollection: .isReadDiscounts,
                        uid: user.uid,
                        id: selectedDiscounts[indexPath.row].info.discountId,
                        loadingAnimation: self.startLoadingAnimation(viewController:),
                        addIdCompletionHandler: { _ in
                            
                            NotificationCenter.default.post(
                                name: Notification.Name(rawValue: NotificationNames.updateReadDiscount.rawValue),
                                object: nil
                            )
                    })
                }
            }
        default: return
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

// MARK: - TableView

extension DRecommViewController: UITableViewDelegate {
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as DRecommTableViewCell = cell else {
            return
        }
        
        if dRecommArray[indexPath.section][indexPath.row].cellHeight == Const.closeCellHeight {
            
            cell.unfold(false, animated: false, completion: nil)
        } else {
            
            cell.unfold(true, animated: false, completion: nil)
        }
        
//                cell.number = indexPath.row
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
        
        markAsRead(indexPath: indexPath)
        
        var duration = 0.0
        let cellIsCollapsed = dRecommArray[indexPath.section][indexPath.row].cellHeight == Const.openCellHeight
        
        if cellIsCollapsed {
            dRecommArray[indexPath.section][indexPath.row].cellHeight = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.5
        } else {
            dRecommArray[indexPath.section][indexPath.row].cellHeight = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
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
        
        if dRecommArray[indexPath.section][indexPath.row].cellHeight == Const.closeCellHeight {

            cell.unfold(false, animated: false, completion: nil)
        } else {

            cell.unfold(true, animated: false, completion: nil)
        }
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        switch indexPath.section {
            
        case 0, 2: // card

            let dRecommData = dRecommArray[indexPath.section][indexPath.row] as? CardBasicInfoObject

            guard let card = dRecommData else { return UITableViewCell() }

            cell.layoutCell(
                image: card.image,
                title: card.name,
                target: card.bank,
                timePeriod: nil,
                note: card.note,
                isRead: card.isRead
            )

            cell.layoutCollectionView(briefIntroArray: card.briefIntro, tagArray: card.tags)

            cell.toDetailHandler = {
                self.performSegue(withIdentifier: Segue.cardDetail, sender: indexPath)
            }

        case 1, 3: // discount

            let dRecommData = dRecommArray[indexPath.section][indexPath.row] as? DiscountDetail

            guard let discount = dRecommData else { return UITableViewCell() }
            
            cell.layoutCell(
                image: discount.info.image,
                title: discount.info.title,
                target: "\(discount.info.bankName) \(discount.info.cardName)",
                timePeriod: discount.info.timePeriod,
                note: discount.note,
                isRead: discount.info.isRead
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
        getUserReadCardId()
        getUserReadDiscountId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.checkReadCard()
            strongSelf.checkReadDiscount()
            
            strongSelf.dRecommArray = [
                strongSelf.newCards,
                strongSelf.newDiscounts,
                strongSelf.selectedCards,
                strongSelf.selectedDiscounts
            ]
            
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
    
    func getUserReadCardId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .isReadCards, completion: { [weak self] ids in
            
            self?.userReadCardIds = ids
            
            self?.group.leave()
        })
    }
    
    func getUserReadDiscountId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .isReadDiscounts, completion: { [weak self] ids in
            
            self?.userReadDiscountIds = ids
            
            self?.group.leave()
        })
    }
    
    func getCategoryDiscountInfo(id: String, completionHandler: @escaping (DRecommSections) -> Void) {
        
        dRecommProvider.getDiscountInfos(id: id, completion: { [weak self] (result) in
            
            switch result {
                
            case .success(let dRecommSections):
                
                completionHandler(dRecommSections)
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    func checkReadCard() {
        
        self.userReadCardIds = HCFirebaseManager.shared.isReadCardIds
        
        for index in 0 ..< newCards.count {
                
//            newCards[index].isRead = false
            
            userReadCardIds.forEach({ (id) in
                
                if newCards[index].id == id {
                    
                    newCards[index].isRead = true
                }
            })
        }
        
        for index in 0 ..< selectedCards.count {
            
//            selectedCards[index].isRead = false
            
            userReadCardIds.forEach({ (id) in
                
                if selectedCards[index].id == id {
                    
                    selectedCards[index].isRead = true
                }
            })
        }
        
        self.dRecommArray = [
            self.newCards,
            self.newDiscounts,
            self.selectedCards,
            self.selectedDiscounts
        ]
    }
    
    func checkReadDiscount() {
        
        self.userReadDiscountIds = HCFirebaseManager.shared.isReadDiscountIds
        
        for index in 0 ..< newDiscounts.count {
            
//            newDiscounts[index].info.isRead = false
            
            userReadDiscountIds.forEach({ (id) in
                
                if newDiscounts[index].info.discountId == id {
                    
                    newDiscounts[index].info.isRead = true
                }
            })
        }
        
        for index in 0 ..< selectedDiscounts.count {
            
//            selectedDiscounts[index].info.isRead = false
            
            userReadDiscountIds.forEach({ (id) in
                
                if selectedDiscounts[index].info.discountId == id {
                    
                    selectedDiscounts[index].info.isRead = true
                }
            })
        }
        
        self.dRecommArray = [
            self.newCards,
            self.newDiscounts,
            self.selectedCards,
            self.selectedDiscounts
        ]
    }
}
