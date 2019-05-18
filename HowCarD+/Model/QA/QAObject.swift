//
//  QAObject.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

struct BankObject: Codable {
    
    let bankId: String
    
    let bankInfo: BankInfo
}

struct BankInfo: Codable {
    
    let bankName: String
    
    let bankIcon: String
    
    let cardCustomerServiceNum: String
    
    let mobileFreeServiceNum: String?
    
    let officialWeb: String
    
    let mailWeb: String?
    
    let qaLink: String?
}
