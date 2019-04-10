//
//  UIView+Extension.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {

    //Border Color
    @IBInspectable var agBorderColor: UIColor? {
        get {

            guard let borderColor = layer.borderColor else {

                return nil
            }

            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    //Border width
    @IBInspectable var agBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    //Corner radius
    @IBInspectable var agCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        
        layer.maskedCorners = corners
        
        layer.cornerRadius = radius
        
        clipsToBounds = true
    }
}
