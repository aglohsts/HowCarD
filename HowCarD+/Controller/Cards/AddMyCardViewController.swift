//
//  AddMyCardViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class AddMyCardViewController: UIViewController {
    
    var selectedDate: Int? = 1
    
    let dates: [ Int ] =
        [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
         21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
        ]
    
    var addMyCardCompletionHandler: ((String?, Bool, Int?) -> Void)?
    
    @IBOutlet weak var billDueDateView: UIView!
    
    @IBOutlet weak var cardNickNameTextField: UITextField!
    
    @IBOutlet weak var billDueDateTextField: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()

        createPickerView()
    }
    
    private func layoutView() {
        
        view.isOpaque = false
//        view.backgroundColor = .clear
    }
    
    @IBAction func onBillRemindSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            billDueDateTextField.isUserInteractionEnabled = true
            
            billDueDateView.backgroundColor = UIColor.tint?.withAlphaComponent(1.0)
            
            needBillRemind = true
            
            selectedDate = 1
            
            guard let dueDate = selectedDate else { return }
            
            billDueDateTextField.text = String(dueDate)
        } else {
            
            billDueDateTextField.isUserInteractionEnabled = false
            
            billDueDateView.backgroundColor = UIColor.tint?.withAlphaComponent(0.5)
            
            needBillRemind = false
            
            selectedDate = nil
            
            billDueDateTextField.text = nil
        }
    }
    
    @IBAction func onAddMyCard(_ sender: Any) {
        
        let nickname = cardNickNameTextField.text == "" ? nil : cardNickNameTextField.text
        
        
        addMyCardCompletionHandler?(nickname, needBillRemind, selectedDate)
        
        self.parent?.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.parent?.tabBarController?.tabBar.isHidden = false
        
        self.willMove(toParent: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParent()
    }
    
    @IBAction func onCancel(_ sender: Any) { 

        self.parent?.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.parent?.tabBarController?.tabBar.isHidden = false
        
        self.willMove(toParent: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParent()
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
