//
//  WalletViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/30.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class WalletViewController: HCBaseViewController {
    
    private struct Segue {
        
        static let myCard = "MyCardSegue"
        
        static let likedDiscount = "LikedDiscountSegue"
        
        static let collectedCard = "collectedCardSegue"
    }
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        
        didSet {
            
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorXConstraint: NSLayoutConstraint!
    
    @IBOutlet var walletButtons: [UIButton]! {
        
        didSet {
            walletButtons[0].setImage(UIImage.asset(.Icons_MyCard_Normal), for: .normal)
            walletButtons[0].setImage(UIImage.asset(.Icons_MyCard_Selected), for: .selected)

            walletButtons[1].setImage(UIImage.asset(.Icons_LikedDiscount_Normal), for: .normal)
            walletButtons[1].setImage(UIImage.asset(.Icons_LikedDiscount_Selected), for: .selected)

            walletButtons[2].setImage(UIImage.asset(.Icons_CollectedCard_Normal), for: .normal)
            walletButtons[2].setImage(UIImage.asset(.Icons_CollectedCard_Selected), for: .selected)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
    }
    
    func setupScrollView() {
        
        scrollView.isPagingEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = false
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
       guard let navigationBarHeight =
                 self.navigationController?.navigationBar.frame.height,
             let tabBarHeight =
                 self.tabBarController?.tabBar.frame.height
             else { return }
        
        scrollView.contentSize = CGSize(
            width: UIScreen.width * 3,
            height: UIScreen.height - topView.frame.height - statusBarHeight - navigationBarHeight - tabBarHeight)
        
        walletButtons[0].isSelected = true
    }
    
    @IBAction func onChangeWalletView(_ sender: UIButton) {
            
        for button in walletButtons {
            
            button.isSelected = false
        }
        
        sender.isSelected = true
        
        moveIndicatorView(toPage: sender.tag)
    }
    
    override func setBackgroundColor2(_ color: HCColor = HCColor.viewBackground) {
        super.setBackgroundColor2()
        
        scrollView.backgroundColor = UIColor.viewBackground
        
        topView.backgroundColor = UIColor.viewBackground
    }
}

extension WalletViewController {
    
    private func moveIndicatorView(toPage: Int) {
        
        
        indicatorXConstraint.constant = CGFloat(toPage) * UIScreen.width / 3
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.scrollView.contentOffset.x = CGFloat(toPage) * UIScreen.width
            
            self?.view.layoutIfNeeded()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.myCard {
            
            guard let myCardVC = segue.destination as? MyCardViewController else { return }
 
        } else if segue.identifier == Segue.likedDiscount {
            
            guard let likedDiscountVC = segue.destination as? LikedDiscountViewController else { return }
            
        } else if segue.identifier == Segue.collectedCard {
            
            guard let collectedCardVC = segue.destination as? CollectedCardViewController else { return }
            
        }
    }
}

extension WalletViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorXConstraint.constant = scrollView.contentOffset.x / 3
        
        let temp = Double(scrollView.contentOffset.x / UIScreen.width)
        
        let index = lround(temp)
        
        for btn in walletButtons {
            
            btn.isSelected = false
        }
        
        walletButtons[index].isSelected = true
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        for index in 0..<walletButtons.count where walletButtons[index].isSelected {
            indicatorXConstraint.constant = size.width * CGFloat(index)
            scrollView.contentOffset.x = size.width * CGFloat(index)
        }
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
        
    }
}
