//
//  FirebaseManager.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/12.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase

private enum FirestoreCollectionReference: String {
    case banks
    case cards
    case users
}

private enum UserDocumentData: String {
    
    case firstName
    
    case lastName
    
    case email
    
    case uid
}

private enum UserCollection: String {
    
    case interestedCards
    
    case likedDiscounts
    
    case myCards
}

private enum DataKey: String {
    
    case discountId
    
    case cardId
}

class HCFirebaseManager {
    
    private init() {}
    
    static let shared = HCFirebaseManager()
    
    var firstDocumentID: String = ""
    
    var secondDocumentID: String = ""
    
    var cards: [CardObject] = []
    
    var level1: [QueryDocumentSnapshot]?
    
    var level2: [QueryDocumentSnapshot]?
    
    var level3: [QueryDocumentSnapshot]?
    
    var cardCompletion: (([QueryDocumentSnapshot]) -> Void)?
    
    func configure() {
        FirebaseApp.configure()
    }
    
    var getDocuments: (() -> [QueryDocumentSnapshot])?
    
    private func firestoreRef(to collectionReference: FirestoreCollectionReference) -> CollectionReference {
        
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func realtimeRef() -> DatabaseReference {
        return Database.database().reference()
    }
    
    func addSignUpListener(listener: @escaping (Bool) -> Void ) {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            
            guard user != nil else {
                // 登出
                
                listener(false)
                
                return
            }
            
            // 登入
            
            listener(true)
            
        }
    }
    
    func addNewUser(uid: String, firstName: String, lastName: String, email: String) {
        
        firestoreRef(to: .users).document(uid).setData([
            UserDocumentData.firstName.rawValue: "\(firstName)",
            UserDocumentData.lastName.rawValue: "\(lastName)",
            UserDocumentData.uid.rawValue: "\(uid)",
            UserDocumentData.email.rawValue: "\(email)"
            ])
    }
    
    func addLikedDiscounts(uid: String, discountId: String) {
        
        firestoreRef(to: .users).document(uid)
            .collection(UserCollection.likedDiscounts.rawValue)
            .addDocument(data: [
                DataKey.discountId.rawValue: "\(discountId)"
                ])
    }
    
    func addInterestedCard() {
        
        
    }
    
    func addBank(_ bank: BankObject) {
        
        firestoreRef(to: .banks).addDocument(data: [
            
            BankObject.CodingKeys.code.rawValue: bank.code,

            BankObject.CodingKeys.contact.rawValue: bank.contact,
            
            BankObject.CodingKeys.fullName.rawValue: bank.fullName,
            
            BankObject.CodingKeys.briefName.rawValue: bank.briefName,
            
            BankObject.CodingKeys.website.rawValue: bank.website
        ])
    }
    
    func showBank(completion: @escaping ([QueryDocumentSnapshot]) -> Void) {

        let query = self.firestoreRef(to: .banks).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                
                guard let error = error else { return }
                
                print("Error fetching document: \(error)")
                
                return
            }

            do {
                try snapshot.documents.forEach({ (documents) in
                    let bankObject: BankObject = try documents.decoded()
                    
                    print(bankObject)
                })
            } catch let error {
                
                print(error)
            }
            
            completion(snapshot.documents)
        }
    }
    
    func addCard(_ card: CardObject) {
        
//        firestoreRef(to: .cards).addDocument(data: [
//            CardObject.CodingKeys.name.rawValue: card.name,
//            
//            CardObject.CodingKeys.bank.rawValue: card.bank,
//            
//            CardObject.CodingKeys.tags.rawValue: card.tags,
//            
//            CardObject.CodingKeys.cardInfoSection.rawValue: card.cardInfoSection
//            
//        ])
    }
    
    func showCard(completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
        
        cardCompletion = completion
        
        self.firestoreRef(to: .cards).addSnapshotListener { (snapshot, error) in
            
            self.level1 = snapshot?.documents
            
            guard let snapshot = snapshot else {
                
                guard let error = error else { return }
                
                print("Error fetching document: \(error)")
                
                return
            }
            
            for document in snapshot.documents {
                
                self.firstDocumentID = document.documentID
            }

            self.showCardSection()
            
            completion(snapshot.documents)

        }
    }
    
    func showCardSection() {
        
        firestoreRef(to: .cards)
            .document(self.firstDocumentID)
            .collection("cardInfoSection")
            .addSnapshotListener { (snapshot, error) in
                
                self.level2 = snapshot?.documents
                
                guard let snapshot = snapshot else {
                    
                    guard let error = error else { return }
                    
                    print("Error fetching document: \(error)")
                    
                    return
                }
                
                for document in snapshot.documents {
                    print(document.data())
//                    print(document.documentID)
                    
                    self.secondDocumentID = document.documentID
                    self.showCardInfo()
                }
        }
    }
    
    func showCardInfo() {
        
        firestoreRef(to: .cards)
            .document(self.firstDocumentID)
            .collection("cardInfoSection")
            .document(self.secondDocumentID)
            .collection("cardInfo")
            .addSnapshotListener { (snapshot, error) in
                
                self.level3 = snapshot?.documents
                
                guard let snapshot = snapshot else {
                    
                    guard let error = error else { return }
                    
                    print("Error fetching document: \(error)")
                    
                    return
                }
                
                for document in snapshot.documents {
                    print(document.data())
                }
        }
    }
}
