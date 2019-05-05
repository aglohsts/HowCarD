//
//  HCWebViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import WebKit

class HCWebViewController: HCBaseViewController {
    
    var goBackObservationToken: NSKeyValueObservation?
    
    var goForwardObservationToken: NSKeyValueObservation?
    
    var webTitleObservationToken: NSKeyValueObservation?
    
    var urlString: String = "" {
        
        didSet {
            
            self.loadURL(urlString: urlString)
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var webTopView: UIView!
    
    @IBOutlet weak var webBottomView: UIView!
    
    @IBOutlet weak var webTitleLabel: UILabel!
    
    @IBOutlet weak var hcWebView: WKWebView! {
        
        didSet {
            
            hcWebView.navigationDelegate = self
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var forwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        view.isOpaque = false
        view.backgroundColor = .clear
        
        webTitleLabel.text = "Loading..."
        
        goBackKVO()
        
        goForwardKVO()
        
        webTitleKVO()
        
        setBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadURL(urlString: self.urlString)
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        
        webTopView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        contentView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        webBottomView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
    }
    
    func loadURL(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        hcWebView.load(URLRequest(url: url))
        
        hcWebView.allowsBackForwardNavigationGestures = true
    }
    
    func setupWebView() {
        
        webTopView.roundCorners(
            [.layerMinXMinYCorner, .layerMaxXMinYCorner],
            radius: 5.0)
        
        contentView.roundCorners(
            [.layerMinXMinYCorner, .layerMaxXMinYCorner],
            radius: 5.0)
        
        webBottomView.addTopBorderWithColor(
            color: .hexStringToUIColor(hex: .grayEFF2F4),
            width: 0.5)
        
        webTopView.addBottomBorderWithColor(
            color: .hexStringToUIColor(hex: .grayEFF2F4),
            width: 0.5)
        
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        
    self.parent?.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.parent?.tabBarController?.tabBar.isHidden = false
        
        self.willMove(toParent: nil)

        self.view.removeFromSuperview()
        
//        self.parent?.navigationController?.isNavigationBarHidden = false

        self.removeFromParent()
        
        loadURL(urlString: "about:blank")
    }
    
    @IBAction func onGoBack(_ sender: Any) {
        
        if hcWebView.canGoBack {
            
            hcWebView.goBack()
        }
    }
    
    @IBAction func onGoForward(_ sender: Any) {
        
        if hcWebView.canGoForward {
            
            hcWebView.goForward()
        }
        
    }
    
    @IBAction func onReload(_ sender: Any) {
        
        hcWebView.reload()
    }
    
    
}

extension HCWebViewController {
    
    func goBackKVO() {
        
        if goBackObservationToken != nil {
            
            return
        }
        
        goBackObservationToken =  observe(\.hcWebView?.canGoBack, options: [.new]) { (strongSelf, change) in
            // return token
            
            guard let canGoBack = change.newValue else { return }
            
            if canGoBack == true {
                
                DispatchQueue.main.async {
                    
                    self.backButton.isEnabled = true
                self.backButton.setImage(UIImage.asset(.Icons_WebGoBack_Enable), for: .normal)
                    
                }
            } else {
                
                DispatchQueue.main.async {
                    
                    self.backButton.isEnabled = false
                    
                    self.backButton.setImage(UIImage.asset(.Icons_WebGoBack_Disable), for: .normal)
                }
            }
        }
    }
    
    func goForwardKVO() {
        
        if goForwardObservationToken != nil {
            
            return
        }
        
        goForwardObservationToken =  observe(\.hcWebView?.canGoForward, options: [.new]) { (strongSelf, change) in
            // return token
            
            guard let canGoForward = change.newValue else { return }
            
            if canGoForward == true {
                
                DispatchQueue.main.async {
                    
                    self.forwardButton.isEnabled = true
                    
                        
                self.forwardButton.setImage(UIImage.asset(.Icons_WebGoForward_Enable), for: .normal)
                    
                }
            } else {
                
                DispatchQueue.main.async {
                    
                    self.forwardButton.isEnabled = false
                    
                    self.forwardButton.setImage(UIImage.asset(.Icons_WebGoForward_Disable), for: .normal)
                }
            }
        }
    }
    
    func webTitleKVO() {
        
        if webTitleObservationToken != nil {
            
            return
        }
        
        webTitleObservationToken =  observe(\.hcWebView?.title, options: [.new]) { (strongSelf, change) in
            // return token
            
            guard let title = change.newValue else { return }
            
            self.webTitleLabel.text = title
        }
        
    }
}

extension HCWebViewController: WKNavigationDelegate {

}
