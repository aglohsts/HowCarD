//
//  DiscountObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/19.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

struct DiscountObject: Codable {
    
    let category: String
    
    let categoryId: String
    
    var discountInfos: [DiscountInfo]
}

struct DiscountInfo: Codable {
    
    let discountId: String
    
    let image: String
    
    let title: String
    
    let bankName: String
    
    let cardId: String
    
    let cardName: String
    
    let timePeriod: String
    
    let lastDate: Int
    
    let officialWeb: String
    
    let isRegisterNeeded: Bool
    
    let registerWeb: String?
    
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        case discountId
        
        case image
        
        case title
        
        case bankName
        
        case cardId
        
        case cardName
        
        case timePeriod
        
        case lastDate
        
        case officialWeb
        
        case isRegisterNeeded
        
        case registerWeb
    }
}

struct DiscountDetail: Codable, Collapsable {
    
    var info: DiscountInfo
    
    let detailContent: [DiscountDetailContent]
    
    let briefIntro: [ BriefIntro ]
    
    let note: String
    
    var cellHeight: CGFloat = 135
    
    enum CodingKeys: String, CodingKey {
        
        case info
        
        case detailContent
        
        case briefIntro
        
        case note
    }
}

struct DiscountDetailContent: Codable {
    
    let briefContent: String
    
    let detailContent: String
}
