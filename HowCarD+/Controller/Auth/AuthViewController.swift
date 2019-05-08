//
//  AuthViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/7.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class AuthViewController: HCBaseViewController {
    
    private struct Segue {
        
        static let signIn = "signInSegue"
        
        static let signUp = "signUpSegue"
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        
        didSet {
            
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorXConstraint: NSLayoutConstraint!
    
    @IBOutlet var authButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        
        layoutButtons()
    }
    
    func setupScrollView() {
        
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * 2,
            height: UIScreen.main.bounds.height - 50 - statusHeight
        )
        
        scrollView.isPagingEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func layoutButtons() {
        
        authButtons.forEach { (button) in
            
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }
    
    @IBAction func onChangeAuthView(_ sender: UIButton) {
        
        switch sender {
            
        case authButtons[0]:
            scrollView.setContentOffset(
                CGPoint(x: 0, y: 0),
                animated: true
            )

        case authButtons[1]:
            scrollView.setContentOffset(
                CGPoint(x: UIScreen.width + 1, y: 0),
                animated: true
            )

        default: return
        }
        
    }
    
    private func moveIndicatorView(toPage: Int) {
        
        indicatorXConstraint.constant = CGFloat(toPage) * UIScreen.width / 2
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.scrollView.contentOffset.x = CGFloat(toPage) * UIScreen.width
            
            self?.view.layoutIfNeeded()
        })
    }
}

extension AuthViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.signIn {
            
            guard let signInVC = segue.destination as? SignInViewController else { return }
            
            signInVC.dismissHandler = {
                
                self.dismiss(animated: true, completion: nil)
            }
            
        } else if segue.identifier == Segue.signUp {
            
            guard let signUpVC = segue.destination as? SignUpViewController else { return }
            
            signUpVC.dismissHandler = {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension AuthViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorXConstraint.constant = scrollView.contentOffset.x / 2
        
        let temp = Double(scrollView.contentOffset.x / UIScreen.width)
        
        let index = lround(temp)
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
}
