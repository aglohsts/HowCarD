//
//  CardsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardsViewController: HCBaseViewController {
    
    var banks = [BankObject]()

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
        
//        HCFirebase.shared.postBank(BankObject(fullName: "台新國際商業銀行", briefName: "台新銀行", code: "812", contact: "(02)2655-3355", website: "https://www.taishinbank.com.tw/"))

        HCFirebase.shared.showBank(completion: { documents in
            
            for document in documents {
                
                self.banks.append(BankObject(
                    fullName: String(describing: document.data()[BankObject.CodingKeys.fullName.rawValue]),
                    briefName: String(describing: document.data()[BankObject.CodingKeys.briefName.rawValue]),
                    code: String(describing: document.data()[BankObject.CodingKeys.code.rawValue]),
                    contact: String(describing: document.data()[BankObject.CodingKeys.contact.rawValue]),
                    website: String(describing: document.data()[BankObject.CodingKeys.website.rawValue])
                ))
                
                
            }
            
            })
        
        

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

extension CardsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}

extension CardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CardInfoTableViewCell.self),
            for: indexPath
        )

        guard let cardInfoCell = cell as? CardInfoTableViewCell else { return cell }

        cardInfoCell.layoutCell(
            tableViewCellIsTapped: true,
            bookMarkIsTapped: true,
            bankIcon: UIImage.asset(.Image_Placeholder) ?? UIImage(),
            bankName: "台新銀行",
            cardImage: UIImage.asset(.Image_Placeholder2) ?? UIImage()
        )

        return cardInfoCell
    }

}
