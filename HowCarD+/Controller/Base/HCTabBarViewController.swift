//
//  HCTabBarViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

enum Tab: String {

    case dRecommend = "D+精選"

    case discounts = "卡好康"

    case cards = "卡了解"

    case wallet = "卡收好"

    case qa = "卡客服"

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .dRecommend:
            controller = UIStoryboard.dRecommend.instantiateInitialViewController()!

        case .discounts:
            controller = UIStoryboard.discounts.instantiateInitialViewController()!

        case .cards:
            controller = UIStoryboard.cards.instantiateInitialViewController()!

        case .wallet:
            controller = UIStoryboard.wallet.instantiateInitialViewController()!

        case .qa:
            controller = UIStoryboard.qa.instantiateInitialViewController()!
        }

        controller.tabBarItem = tabBarItem()

//        controller.navigationItem.title = navBarTitle()

//        controller.tabBarItem.imageInsets = UIEdgeInsets(
//        top: <#T##CGFloat#>,
//        left: <#T##CGFloat#>,
//        bottom: <#T##CGFloat#>,
//        right: <#T##CGFloat#>
//        )

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {
        case .dRecommend:
            return UITabBarItem(
                title: Tab.dRecommend.rawValue,
                image: UIImage.asset(.Icons_36px_DRec_Normal_Line),
                selectedImage: UIImage.asset(.Icons_36px_DRec_Normal_Line)
            )

        case .discounts:
            return UITabBarItem(
                title: Tab.discounts.rawValue,
                image: UIImage.asset(.Icons_36px_Discounts_Normal_Line),
                selectedImage: UIImage.asset(.Icons_36px_Discounts_Normal_Line)
            )

        case .cards:
            return UITabBarItem(
                title: Tab.cards.rawValue,
                image: UIImage.asset(.Icons_36px_Cards_Normal_Line),
                selectedImage: UIImage.asset(.Icons_36px_Cards_Normal_Line)
            )

        case .wallet:
            return UITabBarItem(
                title: Tab.wallet.rawValue,
                image: UIImage.asset(.Icons_36px_Wallet_Normal_Line),
                selectedImage: UIImage.asset(.Icons_36px_Wallet_Normal_Line)
            )

        case .qa:
            return UITabBarItem(
                title: Tab.qa.rawValue,
                image: UIImage.asset(.Icons_36px_QA_Normal_Line),
                selectedImage: UIImage.asset(.Icons_36px_QA_Normal_Line)
            )
        }
    }
}

class HCTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.dRecommend, .discounts, .cards, .wallet, .qa]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self
        
        layoutTabBar()
    }
    
    func layoutTabBar() {
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
    }

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController)
    -> Bool {
        
        guard let navVC = viewController as? UINavigationController,
            let _ = navVC.viewControllers.first as? WalletViewController2
            else { return true }
        
        guard HCFirebaseManager.shared.agAuth().currentUser != nil else {
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                self.present(authVC, animated: true, completion: nil)
            }
            
            return false
        }
        
        return true
    }
    
    func confirmUserSignnedIn() {
        
        if HCFirebaseManager.shared.agAuth().currentUser == nil {
            
            presentAuthVC()
        }
    }
    
    func presentAuthVC() {
        
        if let authVC = UIStoryboard(
            name: StoryboardCategory.auth,
            bundle: nil).instantiateViewController(
                withIdentifier: String(describing: AuthViewController.self)) as? AuthViewController {
            //            let navVC = UINavigationController(rootViewController: authVC)
            
            self.present(authVC, animated: true, completion: nil)
        }
    }

}
