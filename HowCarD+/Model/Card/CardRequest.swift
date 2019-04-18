//
//  CardRequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum CardRequest: HCRequest {
    
    case allCards
    
    var headers: [String: String] {
        
        switch self {
            
        case .allCards: return [:]
            
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .allCards: return nil
            
        }
    }
    
    var method: String {
        
        switch self {
            
        case .allCards: return HCHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .allCards: return "/data/cards.json"
            
        }
    }
}
