//
//  DRecommRequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum DRecommRequest: HCRequest {
    
    case cardDetail(String)
    
    case newCards
    
    case newDiscounts
    
    case selectedCards
    
    case selectedDiscounts
    
    var headers: [String: String] {
        
        switch self {
            
        case .cardDetail(_): return [:]
            
        case .newCards: return [:]
            
        case .newDiscounts: return [:]
            
        case .selectedCards: return [:]
            
        case .selectedDiscounts: return [:]
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .cardDetail(_): return nil
            
        case .newCards: return nil
            
        case .newDiscounts: return nil
            
        case .selectedCards: return nil
            
        case .selectedDiscounts: return nil
        }
    }
    
    var method: String {
        
        switch self {
            
        case .cardDetail(_): return HCHTTPMethod.GET.rawValue
            
        case .newCards: return HCHTTPMethod.GET.rawValue
            
        case .newDiscounts: return HCHTTPMethod.GET.rawValue
            
        case .selectedCards: return HCHTTPMethod.GET.rawValue
            
        case .selectedDiscounts: return HCHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .cardDetail(let id): return "/data/cards/\(id).json"
            
        case .newCards: return "/data/dRecomm/lobby/newCards.json"
            
        case .newDiscounts: return "/data/dRecomm/lobby/newDiscounts.json"
            
        case .selectedCards: return "/data/dRecomm/lobby/selectedCards.json"
            
        case .selectedDiscounts: return "/data/dRecomm/lobby/selectedDiscounts.json"
        }
    }
}
