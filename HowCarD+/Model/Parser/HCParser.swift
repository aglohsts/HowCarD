//
//  HCParser.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/18.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct HCSuccessParser<T: Codable>: Codable {
    
    let data: T
}

struct HCFailureParser: Codable {
    
    let errorMessage: String
}
