//
//  UIViewController+Extention.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/12.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertWith1Action(
        title: String,
        message : String,
        actionButtonText: String = "OK",
        completion: (()->Void)? = nil
        ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: actionButtonText, style: .default) { action in
            print("pressed OK Button")
            
        }
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: completion)
    }
    
    // TODO: 改按選擇後的action
    
    func presentAlertWith3Actions(
        title: String,
        message : String,
        action1ButtonText: String,
        alertAction1: ((UIAlertAction)->Void)?,
        action2ButtonText: String,
        alertAction2: ((UIAlertAction)->Void)?,
        completion: (()->Void)? = nil
        ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: action1ButtonText, style: .default, handler: alertAction1)
 
        let action2 = UIAlertAction(title: action2ButtonText, style: .default, handler: alertAction2)
            
        alertController.addAction(action1)
        
        alertController.addAction(action2)
            
        self.present(alertController, animated: true, completion: completion)
    }
    
    func changeCollectStatus(
        status: Bool,
        userCollection: UserCollection,
        uid: String,
        id: String,
        deleteIdCompletionHandler: (() -> Void)?,
        addIdCompletionHandler: (() -> Void)?,
        changeStatusHandler: () -> Void
        ) {
        
        if status == true {
            
            HCFirebaseManager.shared.deleteId(
                userCollection: userCollection,
                uid: uid,
                id: id
            )
            
            deleteIdCompletionHandler?()
        } else {
            
            HCFirebaseManager.shared.addId(
                userCollection: userCollection,
                uid: uid,
                id: id,
                addIdCompletionHandler: nil
            )
            
            addIdCompletionHandler?()
        }
        
        changeStatusHandler()
    }
}
