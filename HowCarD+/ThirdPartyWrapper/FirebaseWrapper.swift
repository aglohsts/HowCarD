//
//  FirebaseWrapper.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/12.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

enum HCCollectionReference: String {
    case banks
    case cards
}

class HCFirebase {
    
    private init() {}
    
    static let shared = HCFirebase()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: HCCollectionReference) -> CollectionReference {
        
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func postBank(_ bank: BankObject) {
        
        reference(to: .banks).addDocument(data: [
            
            BankObject.CodingKeys.code.rawValue : bank.code,
            
            BankObject.CodingKeys.contact.rawValue : bank.contact,
            
            BankObject.CodingKeys.fullName.rawValue : bank.fullName,
            
            BankObject.CodingKeys.briefName.rawValue : bank.briefName,
            
            BankObject.CodingKeys.website.rawValue : bank.website
        ])
    }
    
}
