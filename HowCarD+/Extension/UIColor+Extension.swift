//
//  UIColor+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/28.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

enum HCColorHex: String {
    
    case viewBackground = "EFEFEF"
    
    case tint = "6FBEDB"
    
    case grayEFF2F4 = "EFF2F4"
    
    case tintBackground = "D5ECF4" // tint
    
    case darkblue = "023246"
    
    case markAsReadBackground = "F4f4f4"
    
    case gray = "C0C3C8"
}

enum HCColor: String {
    
    case tint = "Tint"
    
    case viewBackground = "defaultViewBackground"
    
    case tintBackground = "TintBackground"
}

extension UIColor {
    
    static let tint = HCColor(.tint)
    
    static let viewBackground = HCColor(.viewBackground)
    
    static let tintBackground = HCColor(.tintBackground)
    
    private static func HCColor(_ color: HCColor) -> UIColor? {
        
        return UIColor(named: color.rawValue)
    }
    
    static func hexStringToUIColor(hex: HCColorHex) -> UIColor {
        
        var cString: String = hex.rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
