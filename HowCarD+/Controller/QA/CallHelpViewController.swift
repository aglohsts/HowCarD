//
//  CallHelpViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CallHelpViewController: UIViewController {
    
    let qaProvider = QAProvider()
    
    var bankObjects: [BankObject] = [] {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
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

        getBankInfo()
    }

}

extension CallHelpViewController {
    
    func getBankInfo() {
        
        qaProvider.getBankInfo(completion: { [weak self] (result) in
            
            switch result {
                
            case .success(let bankObjects):
                
                self?.bankObjects = bankObjects
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
}

extension CallHelpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
}

extension CallHelpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bankObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CallHelpTableViewCell.self),
            for: indexPath
        )
        
        guard let callHelpCell = cell as? CallHelpTableViewCell else { return cell }
        
        callHelpCell.layoutCell(
            bankIconImage: bankObjects[indexPath.row].bankInfo.bankIcon,
            bankName: bankObjects[indexPath.row].bankInfo.bankName,
            phoneNumber: bankObjects[indexPath.row].bankInfo.mobileFreeServiceNum ?? bankObjects[indexPath.row].bankInfo.cardCustomerServiceNum)
        
        return callHelpCell
    }
}
