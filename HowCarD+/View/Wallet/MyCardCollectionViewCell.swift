//
//  WalletCollectionViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/22.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import QuartzCore
import HFCardCollectionViewLayout

class WalletCollectionViewCell: HFCardCollectionViewCell {
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    var updateMyCardInfoHandler: ((MyCardObject) -> Void)?
    
    weak var myCardVCUpdateBillInfoDelegate: MyCardVCUpdateBillInfoDelegate?

    @IBOutlet var tableView: UITableView? {
        
        didSet {
            
            tableView?.dataSource = self
            
            tableView?.delegate = self
        }
    }
    @IBOutlet var iconImageView: UIImageView?
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet var backView: UIView?
    @IBOutlet var buttonFlipBack: UIButton?
    
    var myCardObject: MyCardObject? {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView?.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView?.scrollsToTop = false
        
//        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        
        self.tableView?.allowsSelectionDuringEditing = false
        self.tableView?.reloadData()
        
        setupCell()
    }
    
    func cardIsRevealed(_ isRevealed: Bool) {
        self.tableView?.scrollsToTop = isRevealed
    }
}

extension WalletCollectionViewCell {
    
    func layoutCell(cardName: String, imageIcon: String, myCardObject: MyCardObject) {
        
        cardNameLabel.text = cardName
        
        iconImageView?.loadImage(imageIcon, placeHolder: UIImage.asset(.Icons_36px_Cards_Normal))
        
        self.myCardObject = myCardObject
    }
    
    private func setupCell() {
        
        cardNameLabel.text = ""
    }
}

extension WalletCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: BillRemindTableViewCell.self),
                for: indexPath
            )
            
            guard let billRemindCell = cell as? BillRemindTableViewCell else { return UITableViewCell() }
            
            if myCardObject != nil {
                
                billRemindCell.layoutCell(myCardObject: myCardObject!)
            }
            
            billRemindCell.billRemindSwitchDidTouchHandler = { [weak self] (myCardObject) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.myCardObject? = myCardObject
//
//                guard let myCardObject = strongSelf.myCardObject else { return }
                
//                print(indexPath)
                
//                strongSelf.myCardVCUpdateBillInfoDelegate?.updateBillInfo(
//                    myCardObject: myCardObject
//                )
                
                strongSelf.updateMyCardInfoHandler?(myCardObject)
            }
            
            return billRemindCell
            
        case 1:
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: BillDueDateTableViewCell.self),
                for: indexPath
            )
            
            guard let billDueDateCell = cell as? BillDueDateTableViewCell else { return UITableViewCell() }
            
            if myCardObject != nil {
                
                billDueDateCell.layoutCell(myCardObject: myCardObject!)
            }
            
            billDueDateCell.billDueDateUpdateHandler = { [weak self] (myCardObject) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.myCardObject = myCardObject
                
//                guard let myCardObject = strongSelf.myCardObject else { return }
//
//                print(indexPath)
//
//                strongSelf.myCardVCUpdateBillInfoDelegate?.updateBillInfo(
//                    myCardObject: myCardObject
//                )
                
                strongSelf.updateMyCardInfoHandler?(myCardObject)
            }
            
            return billDueDateCell
            
        default:
            
            return UITableViewCell()
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")
//        cell?.textLabel?.text = "Table Cell #\(indexPath.row)"
//        cell?.textLabel?.textColor = .white
//        cell?.backgroundColor = .clear
//        cell?.selectionStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let anAction = UITableViewRowAction(
            style: .default,
            title: "An Action"
        ) { (_, _) -> Void in
            // code for action
        }
        return [anAction]
    }
    
}
