//
//  UIImage+Extension.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    // Tab Bar icon
    case Icons_36px_Cards_Normal
    case Icons_36px_Cards_Selected
    case Icons_36px_QA_Normal
    case Icons_36px_QA_Selected
    case Icons_36px_DRec_Normal
    case Icons_36px_DRec_Selected
    case Icons_36px_Discounts_Normal
    case Icons_36px_Discounts_Selected
    case Icons_36px_Wallet_Normal
    case Icons_36px_Wallet_Selected
    
    // Image
    case Image_Placeholder
    case Image_Placeholder2
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
