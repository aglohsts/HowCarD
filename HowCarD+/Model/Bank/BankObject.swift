//
//  BankObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/12.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct BankObject {
    
    let fullName: String
    
    let briefName: String
    
    let code: String
    
    let contact: String
    
    let website: String
    
    enum CodingKeys: String, CodingKey {
    
        case fullName
        
        case briefName
        
        case code
        
        case contact
        
        case website
    }
}



