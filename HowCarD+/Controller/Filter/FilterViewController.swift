//
//  FilterViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class FilterViewController: HCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
    }
    

    @IBAction func onDoneSelect(_ sender: Any) {
        
        if((self.presentingViewController) != nil){
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setNavBar(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Dismiss), style: .plain, target: self, action: #selector(dismissFilter))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icons_24px_ResetSelect), style: .plain, target: self, action: #selector(resetSelect))
        
    }
    
    @objc private func dismissFilter() {
        
        if((self.presentingViewController) != nil){
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func resetSelect() {
    }

}
