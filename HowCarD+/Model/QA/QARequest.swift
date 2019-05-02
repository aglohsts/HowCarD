//
//  QARequest.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum QARequest: HCRequest {
    
    case bankInfo
    
    var headers: [String: String] {
        
        switch self {
            
        case .bankInfo: return [:]
        }
    }
    
    var body: [String: Any?]? {
        
        switch self {
            
        case .bankInfo: return nil
        }
    }
    
    var method: String {
        
        switch self {
            
        case .bankInfo: return HCHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .bankInfo: return "/data/qa/bankInfo.json"
        }
    }
}
