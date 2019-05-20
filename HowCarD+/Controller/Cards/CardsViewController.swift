//
//  CardsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardsViewController: HCBaseViewController {
    
    let group = DispatchGroup()
    
    var userCollectedCardIds: [String] = []
    
    var userReadCardIds: [String] = []
    
    var addMyCardSelectedPath: IndexPath = [0, 0]
    
    private struct Segue {
        
        static let toDetail = "toCardDetailSegue"
    }
    
    let cardProvider = CardProvider()
    
    var banks: [BankObject] = []
    
    var cardsBasicInfo: [CardBasicInfoObject] = [] {

        didSet {

            DispatchQueue.main.async { [weak self] in

                self?.tableView.reloadData()
            }
        }
    }

    var isFiltered: Bool = false {
        didSet {
            if isFiltered {

                self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                    image: UIImage.asset(.Icons_24px_Filter_Filtered),
                    style: .plain, target: self,
                    action: #selector(showFilter)
                )
            }
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        setBackgroundColor()

//        setNavBar()
        
        getData()
        
        cardAddObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }

    private func setNavBar() {

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Filter_Normal),
            style: .plain,
            target: self,
            action: #selector(showFilter))
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
    }
    
    private func setTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
    }

    @objc private func showFilter() {

        if let filterVC = UIStoryboard(
            name: StoryboardCategory.filter,
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: FilterViewController.self)) as? FilterViewController {
            let navVC = UINavigationController(rootViewController: filterVC)

            self.present(navVC, animated: true, completion: nil)
        }
    }
}

extension CardsViewController {
    
    func getData() {
        
        getCardBasicInfo()
        getUserCollectedCardId()
        getUserReadCardId()
        getMyCardId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            self?.checkCollectedCard()
            
            self?.checkReadCard()
            
            self?.checkMyCard()
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
            }
        })
    }
    
    func getUserCollectedCardId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .collectedCards, completion: { [weak self] ids in
            
            self?.userCollectedCardIds = ids
            // get HCFirebaseManager.shared.collectedCardIds
            
            self?.group.leave()
        })
    }
    
    func getCardBasicInfo() {
        
        group.enter()
        
        cardProvider.getCardBasicInfo(completion: { [weak self] result in
            
            switch result {
                
            case .success(let cardsBasicInfo):
                
                self?.cardsBasicInfo = cardsBasicInfo
                
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
            // get HCFirebaseManager.shared.isReadCardIds
            
            self?.group.leave()
        })
    }
    
    func getMyCardId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .myCards, completion: { [weak self] ids in
            
            // get HCFirebaseManager.shared.myCardIds
            
            self?.group.leave()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toDetail {
            
            let cardDetailVC = segue.destination as? CardDetailViewController
            
            guard let datas = sender as? (IndexPath, Bool, Bool) else { return }
            
            markCardAsRead(indexPath: datas.0)
            
            cardDetailVC?.cardID = cardsBasicInfo[datas.0.row].id
            
            cardDetailVC?.loadViewIfNeeded()
            
            guard let vc = cardDetailVC else { return }
            
            vc.isCollected = datas.1
            
            vc.isMyCard = datas.2
            
            vc.cardCollectDidTouchHandler = { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.cardsBasicInfo[datas.0.row].isCollected = vc.isCollected
            }
            
            vc.isMyCardDidTouchHandler = { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.cardsBasicInfo[datas.0.row].isMyCard = vc.isMyCard
            }
        }
    }
    
    func markCardAsRead(indexPath: IndexPath) {

        cardsBasicInfo[indexPath.row].isRead = true
        
        // 先檢查有無重複
        if userReadCardIds.contains(cardsBasicInfo[indexPath.row].id) {
            
            return
        } else {
            userReadCardIds.append(cardsBasicInfo[indexPath.row].id)
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
            
            HCFirebaseManager.shared.addId(
                viewController: self,
                userCollection: .isReadCards,
                uid: user.uid,
                id: cardsBasicInfo[indexPath.row].id,
                loadingAnimation: nil,
                addIdCompletionHandler: nil
            )
        }
    }
    
    func cardAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateCollectedCard),
                name: NSNotification.Name(NotificationNames.updateCollectedCard.rawValue),
                object: nil
        )
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateReadCard),
                name: NSNotification.Name(NotificationNames.updateReadCard.rawValue),
                object: nil
        )
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateMyCard),
                name: NSNotification.Name(NotificationNames.myCardVCUpdateMyCard.rawValue),
                object: nil
        )
    }
    
    @objc func updateCollectedCard() {
        
        checkCollectedCard()
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
//            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    @objc func updateReadCard() {
        
        checkReadCard()
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
            
//            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    @objc func updateMyCard() {
        
        checkMyCard()
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
            
//            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    func checkCollectedCard() {
        
        /// 比對 id 有哪些 isCollected == true，true 的話改物件狀態
        for index in 0 ..< self.cardsBasicInfo.count {
            
            if cardsBasicInfo[index].isCollected != false {
                
                cardsBasicInfo[index].isCollected = false
            }
            
            HCFirebaseManager.shared.collectedCardIds.forEach ({ (id) in
                
                if cardsBasicInfo[index].id == id {
                    
                    cardsBasicInfo[index].isCollected = true
                }
            })
        }
    }
    
    func checkReadCard() {
        
        /// 比對 id 有哪些 isRead == true，true 的話改物件狀態
        for index in 0 ..< self.cardsBasicInfo.count {
            
            if cardsBasicInfo[index].isRead != false {
                
                cardsBasicInfo[index].isRead = false
            }
            
            HCFirebaseManager.shared.isReadCardIds.forEach ({ (id) in
                
                if cardsBasicInfo[index].id == id {
                    
                    cardsBasicInfo[index].isRead = true
                }
            })
        }
    }
    
    func checkMyCard() {
        
        /// 比對 id 有哪些 isMyCard == true，true 的話改物件狀態
        for index in 0 ..< self.cardsBasicInfo.count {
            
            if cardsBasicInfo[index].isMyCard != false {
                
                cardsBasicInfo[index].isMyCard = false
            }
            
            HCFirebaseManager.shared.myCardIds.forEach ({ (id) in
                
                if cardsBasicInfo[index].id == id {
                    
                    cardsBasicInfo[index].isMyCard = true
                }
            })
        }
    }
}

extension CardsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
}

extension CardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cardsBasicInfo.count
    }

    // TODO: 縮短 function
    // swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CardInfoTableViewCell.self),
            for: indexPath
        )

        guard let cardInfoCell = cell as? CardInfoTableViewCell else { return cell }

        cardInfoCell.layoutCell(
            isRead: cardsBasicInfo[indexPath.row].isRead,
            isCollected: cardsBasicInfo[indexPath.row].isCollected,
            isMyCard: cardsBasicInfo[indexPath.row].isMyCard,
            bankName: cardsBasicInfo[indexPath.row].bank,
            cardName: cardsBasicInfo[indexPath.row].name,
            cardImage: cardsBasicInfo[indexPath.row].image,
            tags: cardsBasicInfo[indexPath.row].tags,
            briefInfos: cardsBasicInfo[indexPath.row].briefIntro
        )
        
        cardInfoCell.toCardDetailHandler = { [weak self] in
            
            self?.performSegue(
                withIdentifier: Segue.toDetail,
                sender: (indexPath,
                         self?.cardsBasicInfo[indexPath.row].isCollected,
                         self?.cardsBasicInfo[indexPath.row].isMyCard)
            )
        }
        
        cardInfoCell.collectButtonDidTouchHandler = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            HCFirebaseManager.shared.checkUserSignnedIn(viewController: strongSelf, checkedSignnedInCompletionHandler: {
                
                guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
                
                strongSelf.changeCollectStatus(
                    status: strongSelf.cardsBasicInfo[indexPath.row].isCollected,
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: strongSelf.cardsBasicInfo[indexPath.row].id,
                    loadingAnimation: strongSelf.startLoadingAnimation(viewController:),
                    deleteIdCompletionHandler: nil,
                    addIdCompletionHandler: nil,
                    changeStatusHandler: {
                        
                        strongSelf.cardsBasicInfo[indexPath.row].isCollected =
                            !strongSelf.cardsBasicInfo[indexPath.row].isCollected

                        NotificationCenter.default.post(
                            name: Notification.Name(rawValue: NotificationNames.updateCollectedCard.rawValue),
                            object: nil
                        )
                    })
            })
        }
        
        // 去官網
        cardInfoCell.toOfficialWebHandler = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.openWebView(
                url: strongSelf.cardsBasicInfo[indexPath.row].officialWeb
            )
        }
        
        // 去辦卡
        cardInfoCell.toApplyCardHandler = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.openWebView(
                url: strongSelf.cardsBasicInfo[indexPath.row].getCardWeb
            )
        }
        
        // cell 中按下 isMyCardBtn
        cardInfoCell.isMyCardDidTouchHandler = { [weak self] in
            
            guard let strongSelf = self, let addMyCardVC = UIStoryboard(
                name: StoryboardCategory.cards,
                bundle: nil).instantiateViewController(
                    withIdentifier: String(describing: AddMyCardViewController.self)) as? AddMyCardViewController
                else { return }
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
            
       // 確認已登入
            HCFirebaseManager.shared.checkUserSignnedIn(viewController: strongSelf, checkedSignnedInCompletionHandler: {
                
                guard let strongSelf = self else { return }
            
                // 確認已登入後做的事：
                if strongSelf.cardsBasicInfo[indexPath.row].isMyCard {
                    
                    // TODO: 跳 alert 確定移除我的卡片嗎
                    
                    HCFirebaseManager.shared.deleteId(
                        viewController: strongSelf,
                        userCollection: .myCards,
                        uid: user.uid,
                        id: strongSelf.cardsBasicInfo[indexPath.row].id,
                        loadingAnimation: strongSelf.startLoadingAnimation(viewController:),
                        completion: { result in
                            
                            switch result {
                                
                            case .success:
                                
                                NotificationCenter.default.post(
                                    name: Notification.Name(rawValue: NotificationNames.cardVCUpdateMyCard.rawValue),
                                    object: nil
                                )
                                
                            case .failure: break
                            }
                        }
                    )
                    strongSelf.cardsBasicInfo[indexPath.row].isMyCard = !strongSelf.cardsBasicInfo[indexPath.row].isMyCard
                    
                } else {
                    
                    // add AddMyCardVC view
                
                    strongSelf.view.endEditing(true)
                    
                    strongSelf.navigationController?.setNavigationBarHidden(true, animated: true)
                    
//                    strongSelf.tabBarController?.tabBar.isHidden = true
                    
                    strongSelf.addChild(addMyCardVC)

                    addMyCardVC.loadViewIfNeeded()
//                    addMyCardVC.view.translatesAutoresizingMaskIntoConstraints = false
                    
                    addMyCardVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    
                    strongSelf.view.addSubview(addMyCardVC.view)
 
//                    addMyCardVC.view.topAnchor.constraint(equalTo: strongSelf.view.topAnchor, constant: 0).isActive = true
//
//                    addMyCardVC.view.leadingAnchor.constraint(equalTo: strongSelf.view.leadingAnchor).isActive = true
//
//                    addMyCardVC.view.trailingAnchor.constraint(equalTo: strongSelf.view.trailingAnchor).isActive = true
//
//                    addMyCardVC.view.bottomAnchor.constraint(equalTo: strongSelf.view.bottomAnchor).isActive = true
                    
                    addMyCardVC.didMove(toParent: strongSelf)
                    
                   // 在 addMyCardVC 中按下確定新增
                    addMyCardVC.addMyCardCompletionHandler = { (nickname, needBillRemind, selectedDate) in
                        // 按下確定要新增再新增id
                        HCFirebaseManager.shared.addId(
                            viewController: strongSelf,
                            userCollection: .myCards,
                            uid: user.uid,
                            id: strongSelf.cardsBasicInfo[indexPath.row].id,
                            loadingAnimation: strongSelf.startLoadingAnimation(viewController:),
                            addIdCompletionHandler: { error in
                                
                                HCFirebaseManager.shared.setMyCard(
                                    uid: user.uid,
                                    id: strongSelf.cardsBasicInfo[indexPath.row].id,
                                    nickname: nickname,
                                    needBillRemind: needBillRemind,
                                    billDueDate: selectedDate,
                                    completion: { _ in
                                        
                                        NotificationCenter.default.post(
                                            name: Notification.Name(rawValue: NotificationNames.cardVCUpdateMyCard.rawValue),
                                            object: nil
                                        )
                                    }
                                )
                        })
                        
                        strongSelf.cardsBasicInfo[indexPath.row].isMyCard = !strongSelf.cardsBasicInfo[indexPath.row].isMyCard
                    }
                }
            })
        }
        return cardInfoCell
    }
}

// swiftlint:enable function_body_length
