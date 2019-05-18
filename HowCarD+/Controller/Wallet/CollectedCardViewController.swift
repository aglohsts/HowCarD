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
    
    @IBOutlet weak var searchBar: UISearchBar! {
        
        didSet {
            
            searchBar.delegate = self
        }
    }
    
    let cardProvider = CardProvider()
    
    var cardsBasicInfo: [CardBasicInfoObject] = []
    
    var userCollectedCards: [CardBasicInfoObject] = []
    
    var searchResult: [CardBasicInfoObject] = []  {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
            }
        }
    }
    
    var isSearching = false
    
    var isDeleting: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cardAddObserver()
        
        setupTableView()
        
        setBackgroundColor()

        getData()
        
        setupSearchBar()
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
            
            HCFirebaseManager.shared.collectedCardIds.forEach({ (id) in
                
                for index in 0 ..< self.cardsBasicInfo.count {
                    
                    if id == self.cardsBasicInfo[index].id {
                        
                        self.userCollectedCards.append(self.cardsBasicInfo[index])
                    }
                }
            })
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
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
        
        /// 先清空 userCollectedCards 再比
        self.userCollectedCards = []
        
        /// 比對 id 有哪些 isLike == true，true 的話改物件狀態
        HCFirebaseManager.shared.collectedCardIds.forEach({ (id) in
            
            for index in 0 ..< self.cardsBasicInfo.count {
                    
                if self.cardsBasicInfo[index].id == id {
                    
                    /// isLiked == true 的物件 append 進 userCollectedCards
                    self.userCollectedCards.append(self.cardsBasicInfo[index])
                }
            }
        })
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
        }
    }
    
    private func setupSearchBar() {
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideUISearchBar?.textColor = UIColor.darkGray
        
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(13)
        
        // SearchBar placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        
        textFieldInsideUISearchBarLabel?.textColor = UIColor.lightGray
    }
}

extension CollectedCardViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            isSearching = false
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
            }
        } else {
            
            searchResult = userCollectedCards.filter({
                
                $0.bank.contains(searchText) ||
                $0.id.contains(searchText) ||
                $0.name.uppercased().contains(searchText.uppercased()) ||
                $0.name.lowercased().contains(searchText.lowercased())
                
            })
            
            isSearching = true
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
        
        if isSearching {
            
            return searchResult.count
        } else {
            
            return userCollectedCards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CollectedCardTableViewCell.self),
            for: indexPath
        )
        
        guard let collectedCardCell = cell as? CollectedCardTableViewCell else { return cell }
        
        
        
        if isSearching {
            
            collectedCardCell.layoutCell(
                cardImage: searchResult[indexPath.row].image,
                cardName: searchResult[indexPath.row].name,
                bankName: searchResult[indexPath.row].bank,
                tags: searchResult[indexPath.row].tags,
                isDeleting: isDeleting)
            
        } else {
            
            collectedCardCell.layoutCell(
                cardImage: userCollectedCards[indexPath.row].image,
                cardName: userCollectedCards[indexPath.row].name,
                bankName: userCollectedCards[indexPath.row].bank,
                tags: userCollectedCards[indexPath.row].tags,
                isDeleting: isDeleting)
        }
        
        collectedCardCell.deleteDidTouchHandler = {
            
            [weak self] in
            
            guard let strongSelf = self,
                let user = HCFirebaseManager.shared.agAuth().currentUser else {
                    return
            }
            
            if strongSelf.isSearching {
                
                HCFirebaseManager.shared.deleteId(
                    viewController: strongSelf,
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: strongSelf.searchResult[indexPath.row].id,
                    loadingAnimation: strongSelf.startLoadingAnimation(viewController:)
                )
                
//                strongSelf.searchResult.remove(at: indexPath.row)
                
            } else {
                
                HCFirebaseManager.shared.deleteId(
                    viewController: strongSelf,
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: strongSelf.userCollectedCards[indexPath.row].id,
                    loadingAnimation: strongSelf.startLoadingAnimation(viewController:)
                )
                
//                strongSelf.userCollectedCards.remove(at: indexPath.row)
            }
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: NotificationNames.updateCollectedCard.rawValue),
                object: nil
            )
        }
        
        return collectedCardCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
}
