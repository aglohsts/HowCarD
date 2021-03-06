//
//  BaseViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import IQKeyboardManager
import NVActivityIndicatorView

extension Tab {
    func navBarTitle() -> String {

        switch self {
        case .dRecommend: return Tab.dRecommend.rawValue

        case .discounts: return Tab.discounts.rawValue

        case .cards: return Tab.cards.rawValue

        case .wallet: return Tab.wallet.rawValue

        case .qa: return Tab.qa.rawValue
        }
    }

}

class HCBaseViewController: UIViewController, NVActivityIndicatorViewable {

    private let tabs: [Tab] = [.dRecommend, .discounts, .cards, .wallet, .qa]

    var isHideNavigationBar: Bool {

        return false
    }

    var isEnableResignOnTouchOutside: Bool {

        return true
    }

    var isEnableIQKeyboard: Bool {

        return true
    }
    
    var isHideNavigationBarUnderLine: Bool {
        
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor(.viewBackground)

        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        
        if isHideNavigationBarUnderLine {
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }

//        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.9)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.backIndicatorImage = UIImage.asset(.Icons_24px_Back)

        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.asset(.Icons_24px_Back)

        navigationController?.navigationBar.tintColor = UIColor(red: 111/255, green: 190/255, blue: 219/255, alpha: 1)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }

        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = false
        }

        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        }
        
        if isHideNavigationBarUnderLine {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }

        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = true
        }

        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        }
        
        if isHideNavigationBarUnderLine {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    func hideNavBarShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
    }

    @IBAction func popBack(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)
    }
    
    func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }
    
    func setBackgroundColor2(_ color: HCColor = HCColor.viewBackground) {
        
        view.backgroundColor = UIColor(named: color.rawValue)
    }
    
    func startLoadingAnimation(viewController: UIViewController) {
        
        let loadingView = NVActivityIndicatorView(
            frame: CGRect(
                x: 0, y: 0,
                width: 80,
                height: 80),
            type: .ballRotateChase,
            color: .white,
            padding: 20)
        
        loadingView.center = self.view.center
        
        self.view.addSubview(loadingView)
        
        let size = CGSize(width: 80, height: 80)
        
        self.startAnimating(
            size,
            message: nil,
            messageFont: nil,
            type: .pacman,
            color: .white,
            padding: 20,
            displayTimeThreshold: nil,
            minimumDisplayTime: nil,
            backgroundColor: nil,
            textColor: .white,
            fadeInAnimation: nil
        )
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating(nil)
        }
    }
}
