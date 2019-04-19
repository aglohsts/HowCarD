//
//  CardProvider.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

typealias CardHandler = (Result<CardObject>) -> Void

typealias CardBasicInfoHandler = (Result<[CardBasicInfoObject]>) -> Void

class CardProvider {
    
    let decoder = JSONDecoder()
    
    func getCards(id: String, completion: @escaping CardHandler) {
        
        HTTPClient.shared.request(CardRequest.cardDetail(id), completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
//                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let cardObject = try strongSelf.decoder.decode(CardObject.self, from: data)
                    
                    completion(Result.success(cardObject))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
    
    func getCardBasicInfo(completion: @escaping CardBasicInfoHandler) {
        
        HTTPClient.shared.request(CardRequest.basicInfo, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    // let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let cardBasicInfoObject = try strongSelf.decoder.decode([CardBasicInfoObject].self, from: data)
                    
                    completion(Result.success(cardBasicInfoObject))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
}
