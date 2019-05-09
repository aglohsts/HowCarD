//
//  FirebaseManager+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

enum HCFirebaseStorageEndpoint: String {
    
    case dRecommTop = "dRecomm/top"
}

extension HCFirebaseManager {
    
    func storageRef() -> StorageReference {
        
        return Storage.storage().reference()
    }
    
    func generateURL(endPoint: HCFirebaseStorageEndpoint, path: String, urlCompletion: @escaping ((URL) -> Void)) {
  
        storageRef().child("dRecomm/top/Icons_cvs.png").downloadURL(completion: { (url, error) in
            
            //\(endPoint.rawValue)\(path)
            print(url)
            if let error = error {
                
                print(error.localizedDescription)
            }
            
            guard let url = url else { return }
            
            urlCompletion(url)
            })
    }
    
    func getURL(urlCompletion: @escaping ((URL) -> Void)) {
        
        storageRef().child("dRecomm/top/Icons_cvs.png").downloadURL(completion: { (url, error) in
            
            print(url)
            
            guard let url = url else { return }
            
            urlCompletion(url)
            
        })
    }
    
    func checkUserSignnedIn(viewController: UIViewController, checkedSignnedInCompletionHandler: (() -> Void)?) {
        
        if HCFirebaseManager.shared.agAuth().currentUser != nil {
            
            checkedSignnedInCompletionHandler?()
            
        } else {
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                let navVC = UINavigationController(rootViewController: authVC)
                
                viewController.present(navVC, animated: true, completion: nil)
            }
        }
    }
}
