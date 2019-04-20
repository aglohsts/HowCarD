//
//  DiscountProvider.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/19.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

typealias DiscountHandler = (Result<[DiscountObject]>) -> Void

class DiscountProvider {
    
    let decoder = JSONDecoder()
    
    func getCards(completion: @escaping DiscountHandler) {
        
        HTTPClient.shared.request(DiscountRequest.allDiscount, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let discountObjects = try strongSelf.decoder.decode([DiscountObject].self, from: data)
                    
                    completion(Result.success(discountObjects))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
}
