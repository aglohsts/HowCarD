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

struct DRecommTop {
    
    let category: String
    
    let caategoryId: String
    
    let image: UIImage
}

struct DRecommTopObjct: Codable {
    
    let category: String // 超商
    
    let categoryId: String // cvs
    
    let sections: [DRecommSection]
}

struct DRecommSection: Codable {
    
    let sectionTitle: String // 711, 全家
    
    let discountInfo: [DiscountInfo]
}
