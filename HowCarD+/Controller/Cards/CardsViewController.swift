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
    
    private struct Segue {
        
        static let toDetail = "toCardDetail"
    }
    
    let cardProvider = CardProvider()
    
    var banks = [BankObject]()
    
    var cardsBasicInfo = [CardBasicInfoObject]() {

        didSet {

            DispatchQueue.main.async {

                self.tableView.reloadData()
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

        setNavBar()
        
        getData()
        
        cardAddObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
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
        
        group.notify(queue: .main, execute: { [weak self] in
            
            self?.checkCollectedCard()
            
            self?.checkReadCard()
            
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
            
            self?.group.leave()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toDetail {
            
            let cardDetailVC = segue.destination as? CardDetailViewController
            
            guard let datas = sender as? (IndexPath, Bool) else { return }
            
            cardDetailVC?.cardID = cardsBasicInfo[datas.0.row].id
            
            cardDetailVC?.loadViewIfNeeded()
            
            guard let vc = cardDetailVC else { return }
            
            vc.isCollected = datas.1
            
            vc.cardCollectTouchHandler = { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.cardsBasicInfo[datas.0.row].isCollected = vc.isCollected
                
//                strongSelf.updateIsCollectedCardId()
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
                userCollection: .isReadCards,
                uid: user.uid,
                id: cardsBasicInfo[indexPath.row].id
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
    }
    
    @objc func updateCollectedCard() {
        
        checkCollectedCard()
        
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
    
    func checkCollectedCard() {
        
        userCollectedCardIds = HCFirebaseManager.shared.collectedCardIds
        
        /// 比對 id 有哪些 isCollected == true，true 的話改物件狀態
        for index in 0 ..< self.cardsBasicInfo.count {
            
            if cardsBasicInfo[index].isCollected != false {
                
                cardsBasicInfo[index].isCollected = false
            }
            
            self.userCollectedCardIds.forEach ({ (id) in
                
                if cardsBasicInfo[index].id == id {
                    
                    cardsBasicInfo[index].isCollected = true
                }
            })
        }
    }
    
    func checkReadCard() {
        
        userReadCardIds = HCFirebaseManager.shared.isReadCardIds
        
        /// 比對 id 有哪些 isCollected == true，true 的話改物件狀態
        for index in 0 ..< self.cardsBasicInfo.count {
            
            if cardsBasicInfo[index].isRead != false {
                
                cardsBasicInfo[index].isRead = false
            }
            
            self.userReadCardIds.forEach ({ (id) in
                
                if cardsBasicInfo[index].id == id {
                    
                    cardsBasicInfo[index].isRead = true
                }
            })
        }
    }
}

extension CardsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Segue.toDetail, sender: (indexPath, cardsBasicInfo[indexPath.row].isCollected))
        
        markCardAsRead(indexPath: indexPath)
    }
}

extension CardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cardsBasicInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CardInfoTableViewCell.self),
            for: indexPath
        )

        guard let cardInfoCell = cell as? CardInfoTableViewCell else { return cell }

        cardInfoCell.layoutCell(
            isRead: cardsBasicInfo[indexPath.row].isRead,
            isCollected: cardsBasicInfo[indexPath.row].isCollected,
            bankName: cardsBasicInfo[indexPath.row].bank,
            cardName: cardsBasicInfo[indexPath.row].name,
            cardImage: cardsBasicInfo[indexPath.row].image,
            tags: cardsBasicInfo[indexPath.row].tags
        )
        
        cardInfoCell.collectButtonDidTouchHandler = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
            
            if strongSelf.cardsBasicInfo[indexPath.row].isCollected {
                
                HCFirebaseManager.shared.deleteId(
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: strongSelf.cardsBasicInfo[indexPath.row].id
                )
            } else {
                
                HCFirebaseManager.shared.addId(
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: strongSelf.cardsBasicInfo[indexPath.row].id
                )
            }
            
            strongSelf.cardsBasicInfo[indexPath.row].isCollected = !strongSelf.cardsBasicInfo[indexPath.row].isCollected
            
//            strongSelf.updateIsCollectedCardId()
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: NotificationNames.updateCollectedCard.rawValue),
                object: nil
            )
            
        }
        return cardInfoCell
    }
}
