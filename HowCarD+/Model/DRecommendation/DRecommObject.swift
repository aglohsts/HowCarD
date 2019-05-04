//
//  DRecommObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import UIKit

struct BriefIntro: Codable {
    
    let title: String
    
    let content: String
}

struct DRecommTopObject: Codable {
    
    let categoryTitle: String // 超商
    
    let categoryId: String // cvs
    
    var image: URL?
    
    let categoryFilePath: String
    
    enum CodingKeys: String, CodingKey {
        
        case categoryTitle
        
        case categoryId
        
        case categoryFilePath
    }
}

struct DRecommTopObject2 {
    
    let categoryTitle: String // 超商
    
    let categoryId: String // cvs
    
    var image: ImageAsset
}

struct DRecommSections: Codable {
    
    let categoryTitle: String // 超商
    
    let categoryId: String // cvs
    
    let categoryImage: String
    
    let sectionContent: [DRecommSectionContent]
}

struct DRecommSectionContent: Codable {
    
    let sectionTitle: String // 711, 全家
    
    let sectionImage: String
    
    let subCategory: [DRecommSubCategory]
}

struct DRecommSubCategory: Codable {
    
    let subTitle: String
    
    let subContent: DRecommSubContent
}

struct DRecommSubContent: Codable {
    
    let discountInfos: [DiscountInfo]
}

struct DRecommTopFile {
    
    var path: String = ""
    
    var url: URL?
}
