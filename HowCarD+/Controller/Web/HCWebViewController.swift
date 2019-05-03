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

    @IBOutlet weak var hcWebView: WKWebView! {
        
        didSet {
            
            hcWebView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadURL(urlString: self.urlString)
        
        
    }
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    func loadURL(urlString: String) {
        
        let url = URL(string: urlString)!
        
        hcWebView.load(URLRequest(url: url))
        
        hcWebView.allowsBackForwardNavigationGestures = true
    }
}

extension HCWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        title = webView.title
    }
}
