//
//  QAProvider.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

typealias BankInfoHandler = (Result<[BankObject]>) -> Void

class QAProvider {
    
    let decoder = JSONDecoder()
    
    func getBankInfo(completion: @escaping BankInfoHandler) {
        
        HTTPClient.shared.request(QARequest.bankInfo, completion: { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let data):
                
                do {
                    
//                                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    let bankObjects = try strongSelf.decoder.decode([BankObject].self, from: data)
                    
                    completion(Result.success(bankObjects))
                    
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
            
        })
    }
}
