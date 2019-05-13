//
//  BillRemindTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/13.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class BillRemindTableViewCell: UITableViewCell {
    
    @IBOutlet weak var billRemindSwitch: UISwitch!
    
    var needBillRemind: Bool = true {
        
        didSet {
            
            if needBillRemind {
                
                selectedDate = 1
            } else {
                
                selectedDate = nil
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onBillRemindSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
//            billDueDateTextField.isUserInteractionEnabled = true
//
//            billDueDateView.backgroundColor = UIColor.tint?.withAlphaComponent(1.0)
            
            needBillRemind = true
            
//            selectedDate = 1
//
//            guard let dueDate = selectedDate else { return }
//
//            billDueDateTextField.text = String(dueDate)
            
            //Notification Center
        } else {
            
//            billDueDateTextField.isUserInteractionEnabled = false
//
//            billDueDateView.backgroundColor = UIColor.tint?.withAlphaComponent(0.5)
            
            needBillRemind = false
            
//            selectedDate = nil
//
//            billDueDateTextField.text = nil
            
            //Notification Center
        }
    }
    
    func layoutCell(needBillRemind: Bool) {
        
        self.needBillRemind = needBillRemind
    }
}




