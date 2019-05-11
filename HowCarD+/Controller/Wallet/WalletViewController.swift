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

    @IBOutlet weak var myCardBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        
        didSet {
            
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorXConstraint: NSLayoutConstraint!
    
    @IBOutlet var walletButtons: [UIButton]!
    
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
    }
    
    @IBAction func onChangeWalletView(_ sender: UIButton) {
        
        switch sender {
            
        case walletButtons[0]:
            scrollView.setContentOffset(
                CGPoint(x: 0, y: 0),
                animated: true
            )
            
        case walletButtons[1]:
            scrollView.setContentOffset(
                CGPoint(x: UIScreen.width + 1, y: 0),
                animated: true
            )
        case walletButtons[2]:
            scrollView.setContentOffset(
                CGPoint(x: UIScreen.width * 2 + 1, y: 0),
                animated: true
            )
            
        default: return
        }
        
    }
}

extension WalletViewController {
    
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
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
}
