//
//  CardProvider.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

typealias CardHandler = (Result<[CardObject]>) -> Void

class CardProvider {
    
    let decoder = JSONDecoder()
    
    func getCard(completion: @escaping CardHandler) {
        
        HTTPClient.shared.request(CardRequest.allCards, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    print(json)
                    
                    let cardObject = try strongSelf.decoder.decode([CardObject].self, from: data)
                    
                    print(cardObject)
                    
                    completion(Result.success(cardObject))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
}
