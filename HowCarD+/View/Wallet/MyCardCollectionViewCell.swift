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
    
    @IBOutlet var buttonFlip: UIButton?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var labelText: UILabel?
    @IBOutlet var imageIcon: UIImageView?
    
    @IBOutlet var backView: UIView?
    @IBOutlet var buttonFlipBack: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonFlip?.isHidden = true
        self.tableView?.scrollsToTop = false
        
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.allowsSelectionDuringEditing = false
        self.tableView?.reloadData()
    }
    
    func cardIsRevealed(_ isRevealed: Bool) {
        self.buttonFlip?.isHidden = !isRevealed
        self.tableView?.scrollsToTop = isRevealed
    }
    
    @IBAction func buttonFlipAction() {
        if let backView = self.backView {
            // Same Corner radius like the contentview of the HFCardCollectionViewCell
            backView.layer.cornerRadius = self.cornerRadius
            backView.layer.masksToBounds = true
            
            self.cardCollectionViewLayout?.flipRevealedCard(toView: backView)
        }
    }
}

extension WalletCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")
        cell?.textLabel?.text = "Table Cell #\(indexPath.row)"
        cell?.textLabel?.textColor = .white
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
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
