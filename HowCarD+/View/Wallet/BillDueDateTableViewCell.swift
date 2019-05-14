//
//  BillDueDateTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/13.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class BillDueDateTableViewCell: UITableViewCell {
    
    var dueDateObservationToken: NSKeyValueObservation?
    
    let dates: [ Int ] =
        [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
          11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
          21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    ]
    
    var myCardObject: MyCardObject? {
        
        didSet {
            
            self.reloadInputViews()
        }
    }

    @IBOutlet weak var billDueDateTextField: UITextField!
    
    var billDueDateUpdateHandler: ((MyCardObject) -> Void)?
    
    var needBillRemind: Bool = true {
        
        didSet {
            
            if needBillRemind {
                
                billDueDateTextField.isUserInteractionEnabled = true
                
//                billDueDateTextField.text = String(selectedDate)
                
            } else {
                
                billDueDateTextField.isUserInteractionEnabled = false
                
                billDueDateTextField.text = nil
                
                if myCardObject != nil {
                    
                    myCardObject?.billInfo.billDueDate = nil
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createPickerView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BillDueDateTableViewCell {
    
    func layoutCell(myCardObject: MyCardObject) {
        
        if myCardObject.billInfo.billDueDate == nil {

            billDueDateTextField.text = nil
        } else {

            billDueDateTextField.text = String(myCardObject.billInfo.billDueDate!)
        }

        self.needBillRemind = myCardObject.billInfo.needBillRemind
        
        self.myCardObject = myCardObject
    }
    
    func createPickerView() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        billDueDateTextField.inputView = pickerView
    }
}

extension BillDueDateTableViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(dates[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        myCardObject?.billInfo.billDueDate = dates[row]
        
        guard let date = myCardObject?.billInfo.billDueDate else { return }
        
        billDueDateTextField.text = String(date)
        
        guard let object = myCardObject else { return }
        
        billDueDateUpdateHandler?(object)
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
