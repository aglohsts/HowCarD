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
    
    private enum TabCategory: Int {
        
        case likedDiscount = 0
        
        case collectedCard = 1
    }
    
    private struct Segue {
        
        static let likedDiscount = "LikedDiscountSegue"
        
        static let collectedCard = "collectedCardSegue"
    }
    
    var containerViews: [UIView] {
        
        return [likedDiscountContainerView, collectedCardsContainerView]
    }

    @IBOutlet weak var tabCollectionView: UICollectionView! {
        
        didSet {
            
            tabCollectionView.delegate = self
            
            tabCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var likedDiscountContainerView: UIView!
    
    @IBOutlet weak var collectedCardsContainerView: UIView!
    
    var tabArray: [ImageAsset] = [.Image_Placeholder, .Image_Placeholder2]
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.likedDiscount {
            
            guard let likedDiscountVC = segue.destination as? LikedDiscountViewController else { return }
            
        } else if segue.identifier == Segue.collectedCard {
            
            guard let collectedCardVC = segue.destination as? CollectedCardViewController else { return }
        }
    
    }
    
    private func setNavBar() {
        
        // TODO: Log out icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
        image: UIImage.asset(.Image_Placeholder2),
        style: .plain,
        target: self,
        action: #selector(onSignOut))
    }
    
    private func updateContainer(tab: TabCategory) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch tab {
            
        case .likedDiscount:
            likedDiscountContainerView.isHidden = false
            
        case .collectedCard:
            collectedCardsContainerView.isHidden = false
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
            
        case TabCategory.likedDiscount.rawValue:
            
            updateContainer(tab: .likedDiscount)
            
            performSegue(withIdentifier: Segue.likedDiscount, sender: nil)
            
        case TabCategory.collectedCard.rawValue:
            
            updateContainer(tab: .collectedCard)
            
            performSegue(withIdentifier: Segue.collectedCard, sender: nil)
            
        default: return
        }
    }
}

extension WalletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: WalletTabCollectionViewCell.self),
            for: indexPath
        )
        
        guard let tabCell = cell as? WalletTabCollectionViewCell
            else { return cell }
        
        let selectedIndexPath = NSIndexPath(
            item: TabCategory.likedDiscount.rawValue,
            section: 0
        )
        
        tabCollectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .top)
        
        tabCell.layoutCell(imageAsset: tabArray[indexPath.item])
        
        return tabCell
    }
}
