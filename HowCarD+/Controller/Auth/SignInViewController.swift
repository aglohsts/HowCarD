//
//  SignInViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/12.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: HCBaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var nextTimeButton: UIButton!
    
    var dismissHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        layoutView()
        
        layoutButton()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            // 提示用戶是不是忘記輸入 textfield ？
            
            presentAlertWith1Action(title: "Error", message: "請確認輸入帳號及密碼。")
            
        } else {
            
            guard let email = emailTextField.text,
                let password = passwordTextField.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error == nil {

                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    guard let error = error else { return }
                    
                    self.presentAlertWith1Action(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onNextTime(_ sender: Any) {
        
        dismissHandler?()
    }
    
    private func layoutButton() {
        
        signInButton.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 17)
        
        nextTimeButton.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
            radius: 17)
    }
    
    private func layoutView() {
        
        backView.roundCorners(
            [.layerMinXMinYCorner , .layerMinXMaxYCorner],
            radius: 15.0
        )
        
        emailView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 2.0)
        
        passwordView.roundCorners(
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 2.0)
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        backView.backgroundColor = UIColor.hexStringToUIColor(hex: .tintBackground)
    }
}

extension SignInViewController {
    
    func presentSignUpVC() {
        
        if let signUpVC = UIStoryboard(
            name: StoryboardCategory.auth,
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: SignUpViewController.self)) as? SignUpViewController {
            let navVC = UINavigationController(rootViewController: signUpVC)
            
            self.present(navVC, animated: false, completion: nil)
        }
    }
}
