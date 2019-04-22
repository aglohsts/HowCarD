//
//  WalletViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class WalletViewController: HCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmUserSignnedIn()
    }

    
}

extension WalletViewController {
    
    func confirmUserSignnedIn() {
        
        if Auth.auth().currentUser == nil {
            
            presentSignInVC()
        }
    }
    
    func presentSignInVC() {
        
        if let signInVC = UIStoryboard(
            name: StoryboardCategory.auth,
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: SignInViewController.self)) as? SignInViewController {
            let navVC = UINavigationController(rootViewController: signInVC)
            
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    func presentSignUpVC() {
        
        if let signUpVC = UIStoryboard(
            name: StoryboardCategory.auth,
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: SignUpViewController.self)) as? SignUpViewController {
            let navVC = UINavigationController(rootViewController: signUpVC)
            
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    func signOut() {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                //                let vc = UIStoryboard(name: StoryboardCategory.dRecommend, bundle: nil).instantiateViewController(withIdentifier: String(describing: ))
                //                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
