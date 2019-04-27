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
    
    var cardsBasicInfo = [CardBasicInfoObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }

}

extension CollectedCardViewController {
    
    func getData() {
        
        getCardBasicInfo()
        getUsercollectedCardId()
        
        group.notify(queue: .main, execute: {
            
            // 拿到資料後要比對user收藏的cardID和物件，畫面顯示有收藏的
        })
    }
    
    func getCardBasicInfo() {
        
        // TODO: 打api拿所有card
    }
    
    func getUsercollectedCardId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .collectedCards, completion: { [weak self] ids in
            
            self?.collectedCardIds = ids
            
            self?.group.leave()
        })
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
        
        // TODO: Layout cell
        
        return collectedCardCell
    }
}
