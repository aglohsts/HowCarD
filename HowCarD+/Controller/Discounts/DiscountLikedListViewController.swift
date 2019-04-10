//
//  DiscountLikedListViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountLikedListViewController: HCBaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
    }

}

// Nav Bar
extension DiscountLikedListViewController {
    
    private func setNavBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Dismiss),
            style: .plain,
            target: self,
            action: #selector(dismissSelf))
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage.asset(.Icons_24px_ResetSelect),
//            style: .plain,
//            target: self,
//            action: #selector(resetSelect))
        
    }
    
    @objc private func dismissSelf() {
        
        if (self.presentingViewController) != nil {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension DiscountLikedListViewController: UITableViewDelegate {
    
}

extension DiscountLikedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DiscountLikedListTableViewCell.self),
            for: indexPath
        )
        
        guard let discountLikedListTableViewCell = cell as? DiscountLikedListTableViewCell else { return cell }
        
        return discountLikedListTableViewCell
    }
}
