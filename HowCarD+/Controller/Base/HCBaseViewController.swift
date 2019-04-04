//
//  BaseViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import IQKeyboardManager

class HCBaseViewController: UIViewController {

    var isHideNavigationBar: Bool {
        
        return false
    }
    
    var isEnableResignOnTouchOutside: Bool {
        
        return true
    }
    
    var isEnableIQKeyboard: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.9)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage.asset(.Icons_24px_Back)
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.asset(.Icons_24px_Back)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = false
        }
        
        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = true
        }
        
        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        }
    }
    
    @IBAction func popBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }

}
