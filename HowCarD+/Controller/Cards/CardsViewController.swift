//
//  CardsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardsViewController: HCBaseViewController {
    
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
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        
    }
    
    private func setNavBar(){
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter_Normal), style: .plain, target: self, action: #selector(showFilter))
        
    }
    
    @objc private func showFilter() {
        
        if let filterVC = UIStoryboard(
            name: StoryboardCategory.filter,
            bundle: nil).instantiateViewController(withIdentifier: String(describing: FilterViewController.self)) as? FilterViewController
        {
            let navVC = UINavigationController(rootViewController: filterVC)
            
            self.present(navVC, animated:true, completion: nil)
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
