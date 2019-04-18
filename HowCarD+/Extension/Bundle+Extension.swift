//
//  Bundle+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func HCValueForString(key: String) -> String {
        
        guard let bundleKey = Bundle.main.infoDictionary![key] as? String else { return "" }
        
        return bundleKey
    }
}
