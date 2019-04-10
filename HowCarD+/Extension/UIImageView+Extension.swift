//
//  UIImageView+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/9.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

extension UIImageView {
        
    func agRoundCorners(cornerRadius: Double, corners: UIRectCorner) {
        
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func isRoundedImage() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.clipsToBounds = true
    }
}
