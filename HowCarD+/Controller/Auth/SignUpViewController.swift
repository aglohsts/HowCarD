//
//  SignUpViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/11.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: HCBaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        if emailTextField.text == "" {
            
            presentAlertWith(title: "Error", message: "請輸入帳號、密碼。")
            
        } else {
            
            guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let confirmPwd = confirmPwdTextField.text else { return }
            
            if password == confirmPwd {
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    if error == nil {
                        
                        print("You have successfully signed up")
                        
                        self.dismiss(animated: true, completion: nil)
                        
//                        if let dRecommendVC = UIStoryboard(
//                            name: StoryboardCategory.filter,
//                            bundle: nil).instantiateViewController(
//                                withIdentifier: String(describing: DRecommViewController.self)) as? DRecommViewController {
//                            //                        let navVC = UINavigationController(rootViewController: filterVC)
//
//                            self.present(dRecommendVC, animated: true, completion: nil)
                    } else {
                        
                        guard let error = error else { return }
                        
                        self.presentAlertWith(title: "Error", message: error.localizedDescription)
                    }
                }
            } else {
                presentAlertWith(title: "Error", message: "請確認輸入相同的密碼。")
            }
        }
    }
}
