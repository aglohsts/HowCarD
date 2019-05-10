//
//  AddMyCardViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class AddMyCardViewController: UIViewController {
    
    var selectedDate: Int?
    
    let dates: [ Int ] =
        [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
         21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
        ]

    @IBOutlet weak var cardNickNameTextField: UITextField!
    
    @IBOutlet weak var billDueDateTextField: UITextField!
    
    @IBOutlet weak var billRemindSwitch: UISwitch!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPickerView()
    }
    
    @IBAction func onBillRemindSwitch(_ sender: Any) {
        
        
    }
    
}

extension AddMyCardViewController {
    
    func createPickerView() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        billDueDateTextField.inputView = pickerView
    }
}

extension AddMyCardViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(dates[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedDate = dates[row]
        
        guard let dueDate = selectedDate else { return }
        
        billDueDateTextField.text = String(dueDate)
    }
}

extension AddMyCardViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dates.count
    }
}
