//
//  DRecommCategoryDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
    }

    @IBAction func onDismiss(_ sender: Any) {
        
        self.willMove(toParent: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParent()
    }
    
}
