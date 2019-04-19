//
//  CardRequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum CardRequest: HCRequest {
    
    case cardDetail(String)
    
    case basicInfo
    
    var headers: [String: String] {
        
        switch self {
            
        case .cardDetail(_): return [:]
            
        case .basicInfo: return [:]
            
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .cardDetail(_): return nil
            
        case .basicInfo: return nil
            
        }
    }
    
    var method: String {
        
        switch self {
            
        case .cardDetail(_): return HCHTTPMethod.GET.rawValue
            
        case .basicInfo: return HCHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .cardDetail(let id): return "/data/cards/\(id).json"
            
        case .basicInfo: return "/data/cardsBasic.json"
            
        }
    }
}
