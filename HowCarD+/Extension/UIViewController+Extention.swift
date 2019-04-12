//
//  UIViewController+Extention.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/12.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertWith(title: String, message : String, actionButtonText: String = "OK") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: actionButtonText, style: .default) { action in
            print("pressed OK Button")
            
        }
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
