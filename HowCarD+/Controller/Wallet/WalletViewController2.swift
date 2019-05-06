//
//  WalletViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import HFCardCollectionViewLayout

class WalletViewController2: HCBaseViewController {
    
    override var isHideNavigationBarUnderLine: Bool {

        return true
    }
    
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
    
    var selectedTab = TabCategory.likedDiscount.rawValue

    @IBOutlet weak var tabCollectionView: UICollectionView! {
        
        didSet {
            
            tabCollectionView.delegate = self
            
            tabCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var likedDiscountContainerView: UIView!
    
    @IBOutlet weak var collectedCardsContainerView: UIView!
    
    var tabArray: [ImageAsset] = [.Icons_LikedDiscount, .Icons_CollectedCard]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setBackgroundColor()

//        setNavBar()
        
//        confirmUserSignnedIn()
        
        if selectedTab == TabCategory.likedDiscount.rawValue {
            
            updateContainer(tab: .likedDiscount)
            
            tabCollectionView.selectItem(
                at: IndexPath(item: TabCategory.likedDiscount.rawValue, section: 0),
                animated: false,
                scrollPosition: .left
            )
        } else if selectedTab == TabCategory.collectedCard.rawValue {
            
            updateContainer(tab: .collectedCard)
            
            tabCollectionView.selectItem(
                at: IndexPath(item: TabCategory.collectedCard.rawValue, section: 0),
                animated: false,
                scrollPosition: .left
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        confirmUserSignnedIn()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        tabCollectionView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
}

extension WalletViewController2 {
    
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
        image: UIImage.asset(.Icons_24px_Share),
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

extension WalletViewController2: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            
            return CGSize(width: UIScreen.width / 2, height: 50.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int)
            -> CGFloat {
    
                return 0
        }
    
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int)
            -> CGFloat {
    
                return 0
        }
    //
    //    func collectionView(
    //        _ collectionView: UICollectionView,
    //        layout collectionViewLayout: UICollectionViewLayout,
    //        referenceSizeForHeaderInSection section: Int)
    //        -> CGSize {
    //
    //            return CGSize(width: UIScreen.width, height: 25.0)
    //    }
}

extension WalletViewController2: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
            
        case TabCategory.likedDiscount.rawValue:
            
            updateContainer(tab: .likedDiscount)
            
            selectedTab = TabCategory.likedDiscount.rawValue
            
        case TabCategory.collectedCard.rawValue:
            
            updateContainer(tab: .collectedCard)
            
            selectedTab = TabCategory.collectedCard.rawValue
            
        default: return
        }
    }
}

extension WalletViewController2: UICollectionViewDataSource {
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
        
        if indexPath.item == selectedTab {
            
            tabCell.isSelected = true
        } else {
            
            tabCell.isSelected = false
        }
        
        tabCell.layoutCell(imageAsset: tabArray[indexPath.item])
        
        return tabCell
    }
}
