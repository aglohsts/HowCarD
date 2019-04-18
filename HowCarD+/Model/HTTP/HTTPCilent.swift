//
//  HTTPCilent.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}

enum HCHTTPClientError: Error {
    
    case decodedDataFail
    
    case clientError(Data)
    
    case serverError
    
    case unexpetedError
}

enum HCHTTPMethod: String {
    
    case GET
    
    case POST
}

protocol HCRequest {
    
    var headers: [String: String] { get }
    
    var body: [String: Any?]? { get }
    
    var method: String { get }
    
    var endPoint: String { get }
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let decoder = JSONDecoder()
    
    private let encoder = JSONEncoder()
    
    private init() { }
    
    func request(_ hcRequest: HCRequest, completion: @escaping (Result<Data>) -> Void) {
        
        let request = makeRequest(hcRequest)
        
        let task = URLSession.shared.dataTask(with: makeRequest(hcRequest)) { (data, response, error) in
            
            guard error == nil else {
                
                return completion(Result.failure(error!))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
                
            case 200..<300:
                
                completion(Result.success(data!))
                
            case 400..<500:
                
                completion(Result.failure(HCHTTPClientError.clientError(data!)))
                
            case 500..<600:
                
                completion(Result.failure(HCHTTPClientError.serverError))
                
            default:
                
                completion(Result.failure(HCHTTPClientError.unexpetedError))
                
            }
        }
        
        task.resume()
    }
    
    private func makeRequest(_ hcRequest: HCRequest) -> URLRequest {
        
        let urlString = Bundle.HCValueForString(key: HCConstant.urlKey) + hcRequest.endPoint
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = hcRequest.headers
        
        do {
            
            if let body = hcRequest.body {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            }
            
        } catch let error {
            
            print(error)
        }

        request.httpMethod = hcRequest.method
        
        return request
    }
}
