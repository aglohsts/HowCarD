//
//  CardsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardsViewController: HCBaseViewController {
    
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
//    AF.request("https://www.taishinbank.com.tw/TS/TS02/TS0201/TS020101/TS02010101/TS0201010104/TS020101010409/index.htm").responseString { response in
//            
//            if let html = response.value {
//                print(html)
//            }
//        }

//        getAllCards()
        
        getCardBasicInfo()
        
        setTableView()
        
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
    
    func getCardBasicInfo() {
        
        cardProvider.getCardBasicInfo(completion: { [weak self] result in
            
            switch result {
                
            case .success(let cardsBasicInfo):
                
                print(cardsBasicInfo)
                
                self?.cardsBasicInfo = cardsBasicInfo
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toDetail {
            
            let cardDetailVC = segue.destination as? CardDetailViewController
            
            guard let datas = sender as? (IndexPath, Bool) else { return }
            
            cardDetailVC?.cardID = cardsBasicInfo[datas.0.row].id
            
//            cardDetailVC?.cardObject?.basicInfo.isCollected = datas.1
            
            cardDetailVC?.loadViewIfNeeded()
            
            cardDetailVC?.isCollected = datas.1
            
        }
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
            
            strongSelf.cardsBasicInfo[indexPath.row].isCollected = !strongSelf.cardsBasicInfo[indexPath.row].isCollected
            
            strongSelf.collectedCardIds = strongSelf.cardsBasicInfo.compactMap({ info in
                
                if info.isCollected == true {
                    
                    return info.id
                }
                
                return nil
            })
        }
        return cardInfoCell
    }

}
