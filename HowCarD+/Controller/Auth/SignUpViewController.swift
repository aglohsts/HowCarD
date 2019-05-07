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
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var nextTimeButton: UIButton!
    
    @IBOutlet weak var backView: UIView!
    
    var dismissHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutButton()
        
        layoutView()
    }
    
    private func setNavBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Dismiss),
            style: .plain,
            target: self,
            action: #selector(onDismiss))
    }
    
    private func layoutButton() {
        
        signUpButton.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 17)
        
        nextTimeButton.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 17)
    }
    
    private func layoutView() {
        
        backView.roundCorners(
            [.layerMaxXMinYCorner , .layerMaxXMaxYCorner],
            radius: 15.0
        )
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        backView.backgroundColor = UIColor.hexStringToUIColor(hex: .tintBackground)
    }
    
    @objc private func onDismiss() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" || confirmPwdTextField.text == "" || userNameTextField.text == "" {
            
            presentAlertWith1Action(title: "Error", message: "請輸入您的帳號資訊。")
            
        } else {
            
            guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let confirmPwd = confirmPwdTextField.text,
            let userName = userNameTextField.text else { return }
            
            if password == confirmPwd {
                
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    if error == nil, user != nil {
                        
                        HCFirebaseManager.shared.addNewUser(
                            uid: user!.user.uid,
                            userName: userName,
                            email: email
                        )
                        
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
                        
                        self.presentAlertWith1Action(title: "Error", message: error.localizedDescription)
                    }
                }
            } else {
                presentAlertWith1Action(title: "Error", message: "請確認輸入相同的密碼。")
            }
        }
    }
    
    @IBAction func onNextTime(_ sender: Any) {
        
        dismissHandler?()
    }
    
}
