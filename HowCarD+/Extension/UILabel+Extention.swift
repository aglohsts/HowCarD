//
//  UILabel+Extention.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/6.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func isBoldFont(size: CGFloat) {
        
        self.font = UIFont.boldSystemFont(ofSize: size)
    }
    
    func isRegularFont(size: CGFloat) {
        
        self.font = UIFont.systemFont(ofSize: size)
    }
}
