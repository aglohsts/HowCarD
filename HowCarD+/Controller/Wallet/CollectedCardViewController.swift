//
//  CollectedCardsViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CollectedCardViewController: HCBaseViewController {
    
    let group = DispatchGroup()

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    var userCollectedCardIds: [String] = []
    
    let cardProvider = CardProvider()
    
    var cardsBasicInfo = [CardBasicInfoObject]()
    
    var userCollectedCards = [CardBasicInfoObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cardAddObserver()
        
        setupTableView()
        
        setBackgroundColor()

        getData()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        tableView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
}

extension CollectedCardViewController {
    
    private func getData() {
        
        getCardBasicInfo()
        getUsercollectedCardId()
        
        group.notify(queue: .main, execute: {
            
            // 拿到資料後要比對user收藏的cardID和物件，畫面顯示有收藏的
            
            self.userCollectedCardIds.forEach({ (id) in
                
                for index in 0 ..< self.cardsBasicInfo.count {
                    
                    if id == self.cardsBasicInfo[index].id {
                        
                        self.userCollectedCards.append(self.cardsBasicInfo[index])
                    }
                }
            })
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        })
    }
    
    private func getCardBasicInfo() {
        
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
    
    private func getUsercollectedCardId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .collectedCards, completion: { [weak self] ids in
            
            self?.userCollectedCardIds = ids
            
            self?.group.leave()
        })
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    func cardAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateCollectedCard),
                name: NSNotification.Name(NotificationNames.updateCollectedCard.rawValue),
                object: nil
        )
    }
    
    @objc func updateCollectedCard() {
        
        userCollectedCardIds = HCFirebaseManager.shared.collectedCardIds
        
        /// 先清空 userCollectedCards 再比
        self.userCollectedCards = []
        
        /// 比對 id 有哪些 isLike == true，true 的話改物件狀態
        self.userCollectedCardIds.forEach({ (id) in
            
            for index in 0 ..< self.cardsBasicInfo.count {
                    
                if self.cardsBasicInfo[index].id == id {
                    
                    /// isLiked == true 的物件 append 進 userCollectedCards
                    self.userCollectedCards.append(self.cardsBasicInfo[index])
                }
            }
        })
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
}

extension CollectedCardViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 80
//    }
}

extension CollectedCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userCollectedCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CollectedCardTableViewCell.self),
            for: indexPath
        )
        
        guard let collectedCardCell = cell as? CollectedCardTableViewCell else { return cell }
        
        collectedCardCell.layoutCell(
            cardImage: userCollectedCards[indexPath.row].image,
            cardName: userCollectedCards[indexPath.row].name,
            bankName: userCollectedCards[indexPath.row].bank,
            tags: userCollectedCards[indexPath.row].tags)
        
        return collectedCardCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let selectedIndex = self.userCollectedCardIds.firstIndex(of: userCollectedCards[indexPath.row].id),
                let user = HCFirebaseManager.shared.agAuth().currentUser else {
                    return
            }
            
            userCollectedCardIds.remove(at: selectedIndex)
            
            HCFirebaseManager.shared.deleteId(
                userCollection: .collectedCards,
                uid: user.uid,
                id: self.userCollectedCards[indexPath.row].id
            )
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: NotificationNames.updateCollectedCard.rawValue),
                object: nil
            )
        }
    }
}
