//
//  QueryDocumentSnapshot+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/15.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension QueryDocumentSnapshot {
    
    func decoded<Type: Decodable>() throws -> Type {
        
        let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        
        let object = try JSONDecoder().decode(Type.self, from: jsonData)
        
        return object
    }
}

extension QuerySnapshot {
    
    func decoded<Type: Decodable>() throws -> [Type] {
        
        print(self.documents)
        
        let objects: [Type] = try documents.map({ try $0.decoded() })
        
        return objects
    }
    
}
