//
//  DiscountRequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/19.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum DiscountRequest: HCRequest {
    
    case discountDetail(String)
    
    case discountLobby
    
    case discountByCategory(String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .discountDetail(_): return [:]
            
        case .discountLobby: return [:]
            
        case .discountByCategory(_): return [:]
            
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .discountDetail(_): return nil
            
        case .discountLobby: return nil
            
        case .discountByCategory(_): return nil
        }
    }
    
    var method: String {
        
        switch self {
            
        case .discountDetail(_): return HCHTTPMethod.GET.rawValue
            
        case .discountLobby: return HCHTTPMethod.GET.rawValue
            
        case .discountByCategory(_): return HCHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .discountDetail(let discountId): return "/data/discounts/detail/\(discountId).json"
            
        case .discountLobby: return "/data/discounts/lobby.json"
            
        case .discountByCategory(let categoryId): return "/data/discounts/category/\(categoryId).json"
        }
    }
}
