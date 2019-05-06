//
//  CardObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/13.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

protocol Collapsable {
    
    var cellHeight: CGFloat { get set }
}

struct CardObject: Codable {
    
    var basicInfo: CardBasicInfoObject
    
    var detailInfo: [CardDetailInfo]
}

struct CardBasicInfoObject: Codable, Collapsable {
    
    let bank: String
    
    let id: String
    
    let image: String
    
    let name: String
    
    let officialWeb: String
    
    let getCardWeb: String
    
    let tags: [ Tags.RawValue ]
    
    let briefIntro: [ BriefIntro ]
    
    let note: String
    
    var cellHeight: CGFloat  = 133
    
    var isCollected: Bool = false
    
    var isRead: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        case bank
        
        case id
        
        case image
        
        case name
        
        case officialWeb
        
        case getCardWeb
        
        case tags
        
        case briefIntro
        
        case note
    }
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
    
    var isDetail: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        case title
        
        case briefContent
        
        case detailContent
        
        case timePeriod
        
        case lastDate
    }
}

enum Tags: String {
    case feedback = "回饋"
    
    case internet = "網路購物"
    
    case movie = "電影"
}
