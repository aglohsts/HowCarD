//
//  CardObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/13.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct CardObject: Codable {
    
    let name: String
    
    let bank: String // collection id path
    
    let tags: [Tags.RawValue]
    
    let cardInfoSection: [CardInfoSection]
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case bank
        
        case tags
        
        case cardInfoSection
    }
}

struct CardInfoSection: Codable {
    let sectionTitle: String
    
    let cardInfo: [CardInfo]
    
    enum CodingKeys: String, CodingKey {
        
        case sectionTitle
        
        case cardInfo
    }
}

struct CardInfo: Codable {
    let title: String
    
    let briefContent: String
    
    let detailContent: String?
    
    let timePeriod: String?
    
    let lastDate: Int? // unixTime
    
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
