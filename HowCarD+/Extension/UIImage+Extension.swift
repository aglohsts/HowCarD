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
    // swiftlint:disable identifier_name
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
    
    case Icons_36px_Cards_Normal_Line
    case Icons_36px_QA_Normal_Line
    case Icons_36px_DRec_Normal_Line
    case Icons_36px_Discounts_Normal_Line
    case Icons_36px_Wallet_Normal_Line

    // Nav Bar
    case Icons_24px_Back
    case Icons_24px_Compare
    case Icons_24px_Dismiss
    case Icons_24px_ResetSelect

    // Nav Bar - Cards
    case Icons_24px_Filter_Normal
    case Icons_24px_Filter_Filtered
    case Icons_24px_Share

    // Other Icons - Cards
    case Icons_ApplyCard
    case Icons_Website
    case Icons_ArrowDown
    case Icons_ArrowUp
    case Icons_Bookmark_Normal
    case Icons_Bookmark_Saved

    // Other ICons - Discounts
    case Icons_ArrowRight
    case CircleButtonWhiteBackground
    case Icons_Heart_Normal
    case Icons_Heart_Selected
    
    // Other Icons - DRecomm
    case Icons_Next
    
    case Icons_cvs
    case Icons_gas
    case Icons_internet
    case Icons_mobilePay
    case Icons_movie
    case Icons_oversea
    case Icons_parking
    case Icons_refund
    case Icons_supermarket
    case Icons_travel
    
    // Other Icons - Wallet
    case Icons_CollectedCard
    case Icons_LikedDiscount
    
    // Other Icons - QA
    case Icons_Call
    case Icons_WriteMessage
    
    // Other Icons - Web
    case Icons_WebDismiss_Disable
    case Icons_WebDismiss_Enable
    case Icons_WebGoBack_Disable
    case Icons_WebGoBack_Enable
    case Icons_WebGoForward_Disable
    case Icons_WebGoForward_Enable
    case Icons_WebReload_Disable
    case Icons_WebReload_Enable
    
    // Other Icons - Auth
    case Icons_SignIn
    case Icons_SignUp

    // Image
    case Image_Placeholder
    case Image_Placeholder2
    case Background_Auth

    // swiftlint:enable identifier_name
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
