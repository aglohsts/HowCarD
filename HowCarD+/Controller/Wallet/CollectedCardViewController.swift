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
    
    var collectedCardIds: [String] = []
    
    let cardProvider = CardProvider()
    
    var cardsBasicInfo = [CardBasicInfoObject]()
    
    var userCollectedCards = [CardBasicInfoObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableView()

        getData()
    }
}

extension CollectedCardViewController {
    
    private func getData() {
        
        getCardBasicInfo()
        getUsercollectedCardId()
        
        group.notify(queue: .main, execute: {
            
            // 拿到資料後要比對user收藏的cardID和物件，畫面顯示有收藏的
            
            self.collectedCardIds.forEach({ (id) in
                
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
            
            self?.collectedCardIds = ids
            
            self?.group.leave()
        })
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
    }
}

extension CollectedCardViewController: UITableViewDelegate {
    
}

extension CollectedCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectedCardIds.count
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
}
