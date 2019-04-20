//
//  DiscountRequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/19.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum DiscountRequest: HCRequest {
    
    case cardDetail(String)
    
    case allDiscount
    
    var headers: [String: String] {
        
        switch self {
            
        case .cardDetail(_): return [:]
            
        case .allDiscount: return [:]
            
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .cardDetail(_): return nil
            
        case .allDiscount: return nil
            
        }
    }
    
    var method: String {
        
        switch self {
            
        case .cardDetail(_): return HCHTTPMethod.GET.rawValue
            
        case .allDiscount: return HCHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .cardDetail(let id): return "/data/cards/\(id).json"
            
        case .allDiscount: return "/data/discounts.json"
            
        }
    }
}
