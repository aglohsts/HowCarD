//
//  CallHelpViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import MessageUI

class CallHelpViewController: HCBaseViewController {
    
    let qaProvider = QAProvider()
    
    var bankObjects: [BankObject] = [] {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        
        didSet {
            
            searchBar.delegate = self
        }
    }
    
    var searchResult: [BankObject] = [] {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    var isSearching = false

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBankInfo()
        
        setBackgroundColor()
        
        setupTableView()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
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
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

extension CallHelpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return searchResult.count
            
        } else {
            
            return bankObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CallHelpTableViewCell.self),
            for: indexPath
        )
        
        guard let callHelpCell = cell as? CallHelpTableViewCell else { return cell }
        
        if isSearching {
            
            callHelpCell.layoutCell(
                bankIconImage: searchResult[indexPath.row].bankInfo.bankIcon,
                bankName: searchResult[indexPath.row].bankInfo.bankName,
                bankId: searchResult[indexPath.row].bankId,
                phoneNumber: searchResult[indexPath.row].bankInfo.mobileFreeServiceNum ??
                    searchResult[indexPath.row].bankInfo.cardCustomerServiceNum
            )
            
        } else {
            
            callHelpCell.layoutCell(
                bankIconImage: bankObjects[indexPath.row].bankInfo.bankIcon,
                bankName: bankObjects[indexPath.row].bankInfo.bankName,
                bankId: bankObjects[indexPath.row].bankId,
                phoneNumber: bankObjects[indexPath.row].bankInfo.mobileFreeServiceNum ??
                    bankObjects[indexPath.row].bankInfo.cardCustomerServiceNum
            )
        }
        
        return callHelpCell
    }
}

extension CallHelpViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            isSearching = false
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        } else {
            
            searchResult = bankObjects.filter({
                $0.bankId.prefix(searchResult.count) == searchText ||
                $0.bankInfo.bankName.prefix(searchResult.count) == searchText ||
                $0.bankId.contains(searchText) ||
                $0.bankInfo.bankName.contains(searchText)
                
            })
            
            isSearching = true
        }
    }
}
