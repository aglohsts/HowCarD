//
//  CardObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/13.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct CardObject: Codable {
    
    let basicInfo: CardBasicInfoObject
    
    var detailInfo: [CardDetailInfo]
}

struct CardBasicInfoObject: Codable {
    
    let bank: String
    
    let id: String
    
    let image: String
    
    let name: String
    
    let officialWeb: String
    
    let getCardWeb: String
    
    let tags: [ Tags.RawValue ]
}

struct CardDetailInfo: Codable {
    
    let sectionTitle: String
    
    var content: [ CardContent ]
}

struct CardContent: Codable {
    
    let title: String
    
    let briefContent: String?
    
    let detailContent: String?
    
    let timePeriod: String?
    
    let lastDate: Int? // unixTime
    
    var isDetail: Bool
}

enum Tags: String {
    case feedback = "回饋"
    
    case internet = "網路購物"
    
    case movie = "電影"
}
