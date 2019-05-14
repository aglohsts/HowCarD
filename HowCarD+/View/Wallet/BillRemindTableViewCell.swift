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
    
    var myCardObject: MyCardObject?
    
    var needBillRemind: Bool = true {

        didSet {

            if needBillRemind {

                billRemindSwitch.isOn = true
            } else {

                billRemindSwitch.isOn = false
            }
        }
    }
    
    var billRemindSwitchDidTouchHandler: ((MyCardObject) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onBillRemindSwitch(_ sender: UISwitch) {
        
        needBillRemind = !needBillRemind
        
        myCardObject?.billInfo.needBillRemind = needBillRemind
        
        if needBillRemind == false {
            
            myCardObject?.billInfo.billDueDate = nil
        } else {
            
            myCardObject?.billInfo.billDueDate = 1
        }
        
        guard let object = myCardObject else { return }
        
        billRemindSwitchDidTouchHandler?(object)
    }
    
    func layoutCell(myCardObject: MyCardObject) {
        
        self.myCardObject = myCardObject
        
        self.needBillRemind = myCardObject.billInfo.needBillRemind
    }
}
