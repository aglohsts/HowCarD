//
//  InnerTableView.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class InnerTableView: UITableView {

    override var intrinsicContentSize: CGSize {
        
        self.layoutIfNeeded()
        
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            
            self.invalidateIntrinsicContentSize()
        }
    }

}
