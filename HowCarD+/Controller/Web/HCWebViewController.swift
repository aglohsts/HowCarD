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
    
    var urlString: String = "" {
        
        didSet {
            
            self.loadURL(urlString: urlString)
        }
    }

    @IBOutlet weak var webTitleLabel: UILabel!
    
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
        
        setupWebView()
        
        view.isOpaque = false
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadURL(urlString: self.urlString)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.view.alpha = 1.0
        })
    }
    
    func loadURL(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        hcWebView.load(URLRequest(url: url))
        
        hcWebView.allowsBackForwardNavigationGestures = true
    }
    
    func setupWebView() {
        
        hcWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?, change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        
        if keyPath == "title" {
            if let title = hcWebView.title {
                
                webTitleLabel.text = title
            }
        }
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        
        self.willMove(toParent: nil)

        self.view.removeFromSuperview()

        self.parent?.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
}

extension HCWebViewController: WKNavigationDelegate {

}
