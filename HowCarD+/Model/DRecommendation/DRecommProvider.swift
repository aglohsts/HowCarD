//
//  DRecommProvider.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

typealias NewCardHandler = (Result<[CardBasicInfoObject]>) -> Void

typealias SelectedCardHandler = (Result<[CardBasicInfoObject]>) -> Void

typealias NewDiscountHandler = (Result<[DiscountDetail]>) -> Void

typealias SelectedDiscountHandler = (Result<[DiscountDetail]>) -> Void

class DRecommProvider {
    
    let decoder = JSONDecoder()
    
    func getNewCards(completion: @escaping NewCardHandler) {
        
        HTTPClient.shared.request(DRecommRequest.newCards, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let newCards = try strongSelf.decoder.decode([CardBasicInfoObject].self, from: data)
                    
                    print(newCards)
                    
                    completion(Result.success(newCards))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
    
    func getSelectedCards(completion: @escaping SelectedCardHandler) {
        
        HTTPClient.shared.request(DRecommRequest.selectedCards, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let selectedCards = try strongSelf.decoder.decode([CardBasicInfoObject].self, from: data)
                    
                    print(selectedCards)

                    completion(Result.success(selectedCards))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
    
    func getNewDiscounts(completion: @escaping NewDiscountHandler) {
        
        HTTPClient.shared.request(DRecommRequest.newDiscounts, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let newDiscounts = try strongSelf.decoder.decode([DiscountDetail].self, from: data)
                    
                    print(newDiscounts)

                    completion(Result.success(newDiscounts))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
    
    func getSelectedDiscounts(completion: @escaping SelectedDiscountHandler) {
        
        HTTPClient.shared.request(DRecommRequest.selectedDiscounts, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let selectedDiscounts = try strongSelf.decoder.decode([DiscountDetail].self, from: data)
                    
                    print(selectedDiscounts)

                    completion(Result.success(selectedDiscounts))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
}
