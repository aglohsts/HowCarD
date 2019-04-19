//
//  DiscountObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/19.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct DiscountObject: Codable {
    
    let category: String
    
    let discountInfos: [DiscountInfo]
}

struct DiscountInfo: Codable {
    
    let id: String
    
    let image: String
    
    let title: String
    
    let bankName: String
    
    let cardName: String
    
    let timePeriod: String
    
    let lastDate: Int
}

struct DiscountDetail: Codable {
    
    let info: DiscountInfo
    
    let detailContent: [DiscountDetailContent]
}

struct DiscountDetailContent: Codable {
    
    let briefContent: String
    
    let detailContent: String
}
