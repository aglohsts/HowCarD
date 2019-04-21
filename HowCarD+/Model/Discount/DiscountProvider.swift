//
//  DiscountProvider.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/19.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

typealias DiscountHandler = (Result<[DiscountObject]>) -> Void

typealias DiscountDetailHandler = (Result<DiscountDetail>) -> Void

typealias DiscountByCategotyHandler = (Result<DiscountObject>) -> Void

class DiscountProvider {
    
    let decoder = JSONDecoder()
    
    func getCards(completion: @escaping DiscountHandler) {
        
        HTTPClient.shared.request(DiscountRequest.discountLobby, completion: { [weak self] (result) in
            
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
    
    func getDetail(id: String, completion: @escaping DiscountDetailHandler) {
        
        HTTPClient.shared.request(DiscountRequest.discountDetail(id), completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let discountDetail = try strongSelf.decoder.decode(DiscountDetail.self, from: data)
                    
                    completion(Result.success(discountDetail))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
    
    func getByCategory(id: String, completion: @escaping DiscountByCategotyHandler) {
        
        HTTPClient.shared.request(DiscountRequest.discountByCategory(id), completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let discountObject = try strongSelf.decoder.decode(DiscountObject.self, from: data)
                    
                    completion(Result.success(discountObject))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
}
