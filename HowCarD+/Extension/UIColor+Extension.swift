//
//  UIColor+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/28.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

enum HCColorHex: String {
    
    case viewBackground = "F7F8F3"
    
    case tint = "6FBEDB"
}

extension UIColor {
    
    static func hexStringToUIColor(hex: HCColorHex) -> UIColor {
        
        var cString: String = hex.rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}