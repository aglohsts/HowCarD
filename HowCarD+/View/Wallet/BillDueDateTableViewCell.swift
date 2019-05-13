//
//  BillDueDateTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/13.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class BillDueDateTableViewCell: UITableViewCell {
    
    let dates: [ Int ] =
        [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
          11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
          21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    ]

    @IBOutlet weak var billDueDateTextField: UITextField!
    
    var needBillRemind: Bool = true {
        
        didSet {
            
            if needBillRemind {
                
                billDueDateTextField.isUserInteractionEnabled = true
                
            } else {
                
                billDueDateTextField.isUserInteractionEnabled = false
                
                billDueDateTextField.text = nil
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

}

extension BillDueDateTableViewCell {
    
    func layoutCell(dueDate: Int?, needBillRemind: Bool) {
        
        if dueDate == nil {
            
            billDueDateTextField.text = nil
        } else {
            
            billDueDateTextField.text = String(dueDate!)
        }
        
        self.needBillRemind = needBillRemind
    }
    
    func createPickerView() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        billDueDateTextField.inputView = pickerView
    }
    
    func billDueDateAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateBillInfo),
                name: NSNotification.Name(NotificationNames.updateBillInfo.rawValue),
                object: nil
        )
    }
    
    @objc func updateBillInfo() {
        
        needBillRemind = !needBillRemind
    }
}

extension BillDueDateTableViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(dates[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        billDueDateTextField.text = String(dates[row])
    }
}

extension BillDueDateTableViewCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dates.count
    }
}
