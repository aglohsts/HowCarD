//
//  Array+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/28.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    func removeDuplicates() -> [Element] {
        
        var result = [Element]()
        
        for value in self {
            
            if result.contains(value) == false {
                
                result.append(value)
            }
        }
        return result
    }
}
