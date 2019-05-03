//
//  CallHelpViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import MessageUI
import WebKit

class CallHelpViewController: HCBaseViewController {
    
    let webVC = UIStoryboard(
        name: StoryboardCategory.web,
        bundle: nil).instantiateViewController(
            withIdentifier: String(describing: HCWebViewController.self))
    
    let composer = MFMailComposeViewController()
    
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
        
        setupSearchBar()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
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

extension CallHelpViewController {
    
    func getBankInfo() {
        
        qaProvider.getBankInfo(completion: { [weak self] (result) in
            
            switch result {
                
            case .success(let bankObjects):
                
                self?.bankObjects = bankObjects.sorted(by: { (bankObject, bankObject2) -> Bool in
                    bankObject.bankId < bankObject2.bankId
                })
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    func showMailComposer(email: String) {
        
        guard MFMailComposeViewController.canSendMail() == true else {
            // TODO: Show alert informing user
            return
        }
        
        composer.mailComposeDelegate = self
        
        composer.setToRecipients([email])
        
        composer.setSubject("信用卡問題")
        
        present(composer, animated: true, completion: nil)
    }
}

extension CallHelpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
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
                    searchResult[indexPath.row].bankInfo.cardCustomerServiceNum,
                mailWeb: searchResult[indexPath.row].bankInfo.mailWeb ?? nil
            )
            
//            if searchResult[indexPath.row].bankInfo.mailWeb != nil {
            
                callHelpCell.sendMailHandler = { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
//                    self?.showMailComposer(email: (self?.searchResult[indexPath.row].bankInfo.mailWeb)!)

                    
                    // add view
                    
                    guard let vc = strongSelf.webVC as? HCWebViewController else { return }

                    if vc.view.superview == nil {

                        vc.urlString = self?.searchResult[indexPath.row].bankInfo.mailWeb ?? ""

                        strongSelf.addChild(vc)

                       
                       strongSelf.navigationController?.setNavigationBarHidden(true, animated: true)
//                        strongSelf.navigationController?.isNavigationBarHidden = true

                        vc.view.frame = CGRect(
                            x: 0,
                            y: 0,
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        )

                        vc.didMove(toParent: strongSelf)
                    }

//                }
            }
            
            
        } else {
            
            callHelpCell.layoutCell(
                bankIconImage: bankObjects[indexPath.row].bankInfo.bankIcon,
                bankName: bankObjects[indexPath.row].bankInfo.bankName,
                bankId: bankObjects[indexPath.row].bankId,
                phoneNumber: bankObjects[indexPath.row].bankInfo.mobileFreeServiceNum ??
                    bankObjects[indexPath.row].bankInfo.cardCustomerServiceNum,
                mailWeb: bankObjects[indexPath.row].bankInfo.mailWeb ?? nil
            )
            
//            if bankObjects[indexPath.row].bankInfo.email != nil {
            
                callHelpCell.sendMailHandler = { [weak self] in
                    
                    
//                    guard let strongSelf = self, let vc = strongSelf.webVC else { return }
//                    strongSelf.view.addSubview(vc.view)
//
//                    vc.didMove(toParent: strongSelf)
//
                    
                    
                    
                    
//                    self?.showMailComposer(email: "lohsts@gmail.com")
                }
//            }
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

extension CallHelpViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error {
            // TODO: Show error message
            controller.dismiss(animated: true, completion: nil)

            return
        }

        switch result {
        case .cancelled: print("cancelled")

        case .failed: print("failed")

        case .saved: print("saved")

        case .sent: print("sent")

        @unknown default:

            if let error = error {

                print(error)
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
