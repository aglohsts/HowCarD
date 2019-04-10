//
//  UIImageView+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func isRoundedImage() {
        
        self.layer.cornerRadius = self.frame.size.height / 2
        
        self.clipsToBounds = true
    }
}
