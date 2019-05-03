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
    
    var urlString: String = ""

    @IBOutlet weak var webTitleLabel: UILabel! {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.webTitleLabel.text = self.hcWebView.title
            }
        }
    }
    
    @IBOutlet weak var hcWebView: WKWebView! {
        
        didSet {
            
//            hcWebView.navigationDelegate = self
        }
    }
    @IBOutlet weak var backButton: UIButton!
//        {
//
//        didSet {
//
//            if hcWebView.canGoBack {
//
//                backButton.isEnabled = true
//                // TODO: set button layout
//            } else {
//
//                backButton.isEnabled = false
//            }
//        }
//    }
    
    @IBOutlet weak var forwardButton: UIButton!
//        {
//        
//        didSet {
//            
//            if hcWebView.canGoForward {
//                
//                // TODO: set button layout
//                forwardButton.isEnabled = true
//            } else {
//                
//                forwardButton.isEnabled = false
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadURL(urlString: self.urlString)
        
        setupWebView()
    }
    
    func loadURL(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        hcWebView.load(URLRequest(url: url))
        
        hcWebView.allowsBackForwardNavigationGestures = true
    }
    
    func setupWebView() {
        
        hcWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "title" {
            if let title = hcWebView.title {
                
                webTitleLabel.text = title
            }
        }
    }
    
    @IBAction func onDismiss(_ sender: Any) {
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
}

extension HCWebViewController: WKNavigationDelegate {

}
