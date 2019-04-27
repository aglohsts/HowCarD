//
//  WalletViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import HFCardCollectionViewLayout

class WalletViewController: HCBaseViewController {

    @IBOutlet weak var tabCollectionView: UICollectionView! {
        
        didSet {
            
            tabCollectionView.delegate = self
            
            tabCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var likedDiscountContainerView: UIView!
    
    @IBOutlet weak var collectedCardsContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        
//        confirmUserSignnedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        confirmUserSignnedIn()
    }
}

extension WalletViewController {
    
    private func setNavBar() {
        
        // TODO: Log out icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
        image: UIImage.asset(.Image_Placeholder2),
        style: .plain,
        target: self,
        action: #selector(onSignOut))
    }
    
    @objc private func onSignOut() {
        
        signOut()
    }
    
    func confirmUserSignnedIn() {
        
        if HCFirebaseManager.shared.agAuth().currentUser == nil {
        
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
        
        if HCFirebaseManager.shared.agAuth().currentUser != nil {
            do {
                try HCFirebaseManager.shared.agAuth().signOut()
                //                let vc = UIStoryboard(name: StoryboardCategory.dRecommend, bundle: nil).instantiateViewController(withIdentifier: String(describing: ))
                //                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}

extension WalletViewController: UICollectionViewDelegate {
    
}

extension WalletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
