//
//  DRecommRequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum DRecommRequest: HCRequest {
    
    case newCards
    
    case newDiscounts
    
    case selectedCards
    
    case selectedDiscounts
    
    case topDiscountInfos(String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .newCards: return [:]
            
        case .newDiscounts: return [:]
            
        case .selectedCards: return [:]
            
        case .selectedDiscounts: return [:]
            
        case .topDiscountInfos(_): return [:]
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .newCards: return nil
            
        case .newDiscounts: return nil
            
        case .selectedCards: return nil
            
        case .selectedDiscounts: return nil
            
        case .topDiscountInfos(_): return nil
        }
    }
    
    var method: String {
        
        switch self {
            
        case .newCards: return HCHTTPMethod.GET.rawValue
            
        case .newDiscounts: return HCHTTPMethod.GET.rawValue
            
        case .selectedCards: return HCHTTPMethod.GET.rawValue
            
        case .selectedDiscounts: return HCHTTPMethod.GET.rawValue
            
        case .topDiscountInfos(_): return HCHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .newCards: return "/data/dRecomm/lobby/newCards.json"
            
        case .newDiscounts: return "/data/dRecomm/lobby/newDiscounts.json"
            
        case .selectedCards: return "/data/dRecomm/lobby/selectedCards.json"
            
        case .selectedDiscounts: return "/data/dRecomm/lobby/selectedDiscounts.json"
            
        case .topDiscountInfos(let id): return "/data/dRecomm/topDiscountInfos/\(id).json"
        }
    }
}
