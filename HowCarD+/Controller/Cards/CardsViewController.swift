//
//  CardsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FirebaseAuth

class CardsViewController: HCBaseViewController {
    
    let group = DispatchGroup()
    
    var collectedCardIds = [String]()
    
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

        setNavBar()
        
//        getCardBasicInfo()
        
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData()
    }

    private func setNavBar() {

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Filter_Normal),
            style: .plain,
            target: self,
            action: #selector(showFilter))
    }
    
    private func setTableView() {
        
        tableView.separatorStyle = .none
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
        
        group.notify(queue: .main, execute: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.collectedCardIds.forEach({ (id) in
                
                for index in 0 ..< strongSelf.cardsBasicInfo.count {
                    
                    if strongSelf.cardsBasicInfo[index].id == id {
                        
                        strongSelf.cardsBasicInfo[index].isCollected = true
                    }
                    
                }
                
                DispatchQueue.main.async {
                    
                    strongSelf.tableView.reloadData()
                }
                
                
//                for var cardBasicInfoObject in strongSelf.cardsBasicInfo {
//                    
//                    if cardBasicInfoObject.id == id {
//                        
//                        cardBasicInfoObject.isCollected = true
//                        
//                        DispatchQueue.main.async {
//                            
//                            strongSelf.tableView.reloadData()
//                        }
//                    }
//                }
                
//                strongSelf.cardsBasicInfo.forEach({ (cardBasicInfoObject) in
//
//                    if cardBasicInfoObject.id == id {
//
//                        cardBasicInfoObject.isCollected = true
//                    }
//                })
            })
        })
    }
    
    func getUserCollectedCardId() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: uid, userCollection: .collectedCards, completion: { [weak self] ids in
            
            print(ids)
            
            self?.collectedCardIds = ids
            // TODO
            
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
                
                strongSelf.updateIsCollectedCardId()
            }
        }
    }
    
    func updateIsCollectedCardId() {
        
        self.collectedCardIds = self.cardsBasicInfo.compactMap({ info in
            
            if info.isCollected == true {
                
                return info.id
            }
            
            return nil
        })
        
        print("=======")
        print(collectedCardIds)
    }
    
    
}

extension CardsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Segue.toDetail, sender: (indexPath, cardsBasicInfo[indexPath.row].isCollected))
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
            tableViewCellIsTapped: true,
            isCollected: cardsBasicInfo[indexPath.row].isCollected,
            bankName: cardsBasicInfo[indexPath.row].bank,
            cardName: cardsBasicInfo[indexPath.row].name,
            cardImage: cardsBasicInfo[indexPath.row].image,
            tags: cardsBasicInfo[indexPath.row].tags
        )
        
        cardInfoCell.collectButtonDidTouchHandler = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            if strongSelf.cardsBasicInfo[indexPath.row].isCollected {
                
                HCFirebaseManager.shared.deleteId(userCollection: .collectedCards, uid: uid, id: strongSelf.cardsBasicInfo[indexPath.row].id)
                
            } else {
                
                HCFirebaseManager.shared.addId(userCollection: .collectedCards, uid: uid, id: strongSelf.cardsBasicInfo[indexPath.row].id)
                
            }
            
            strongSelf.cardsBasicInfo[indexPath.row].isCollected = !strongSelf.cardsBasicInfo[indexPath.row].isCollected
            
            strongSelf.updateIsCollectedCardId()
        }
        return cardInfoCell
    }

}
