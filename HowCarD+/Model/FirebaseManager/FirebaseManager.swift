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
import FirebaseAuth

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

enum UserCollection: String {
    
    case collectedCards
    
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
    
    var likedDiscountIds = [String]()
    
    var collectedCardIds = [String]()
    
    var myCardIds = [String]()
    
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
    
    func agAuth() -> Auth {
        
        return Auth.auth()
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
    
    func addLikedDiscount(uid: String, discountId: String) {
        
        firestoreRef(to: .users).document(uid)
            .collection(UserCollection.likedDiscounts.rawValue)
            .addDocument(data: [
                DataKey.discountId.rawValue: "\(discountId)"
                ])
    }
    
    func deleteLikedDiscount(uid: String, discountId: String) {
        
        firestoreRef(to: .users).document(uid)
            .collection(UserCollection.likedDiscounts.rawValue)
            .whereField(DataKey.discountId.rawValue, isEqualTo: discountId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    
                    querySnapshot!.documents.forEach({ [weak self] (document) in
                        
                        // document.documentID
                        // 用 documentID 去刪除 document
                        
                        self?.firestoreRef(to: .users)
                            .document(uid).collection(UserCollection.likedDiscounts.rawValue)
                            .document(document.documentID).delete()
                    })
                }
            }
    }
    
    func addId(userCollection: UserCollection, uid: String, id: String) {
        
        switch userCollection {
            
        case .likedDiscounts:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(data: [
                    DataKey.discountId.rawValue: "\(id)"
                    ])
            
            likedDiscountIds.append(id)
            
        case .collectedCards:
        
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(data: [
                    DataKey.cardId.rawValue: "\(id)"
                    ])
            
            collectedCardIds.append(id)
        
        case .myCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(data: [
                    DataKey.cardId.rawValue: "\(id)"
                    ])
            
            myCardIds.append(id)
        }
    }
    
    func deleteId(userCollection: UserCollection, uid: String, id: String) {
        
        switch userCollection {
            
        case .likedDiscounts:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(DataKey.discountId.rawValue, isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        querySnapshot!.documents.forEach({ [weak self] (document) in
                            // 用 documentID 去刪除 document
                            self?.firestoreRef(to: .users)
                                .document(uid).collection(userCollection.rawValue)
                                .document(document.documentID).delete()
                        })
                    }
            }
            
            guard let index = likedDiscountIds.firstIndex(of: id) else { return }
            
            likedDiscountIds.remove(at: index)
            
        case .collectedCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(DataKey.cardId.rawValue, isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        querySnapshot!.documents.forEach({ [weak self] (document) in
                            // 用 documentID 去刪除 document
                            self?.firestoreRef(to: .users)
                                .document(uid).collection(userCollection.rawValue)
                                .document(document.documentID).delete()
                        })
                    }
            }
            
            guard let index = collectedCardIds.firstIndex(of: id) else { return }
            
            collectedCardIds.remove(at: index)
            
        case .myCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(DataKey.cardId.rawValue, isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        querySnapshot!.documents.forEach({ [weak self] (document) in
                            // 用 documentID 去刪除 document
                            self?.firestoreRef(to: .users)
                                .document(uid).collection(userCollection.rawValue)
                                .document(document.documentID).delete()
                        })
                    }
            }
            
            guard let index = myCardIds.firstIndex(of: id) else { return }
            
            myCardIds.remove(at: index)
        }
    }
    
    func getId(uid: String, userCollection: UserCollection, completion: @escaping ([String]) -> Void) {
        
        switch userCollection {
        case .likedDiscounts:
            
            if likedDiscountIds.count > 0 {
                
                completion(likedDiscountIds)
                
                return
            }
            
            firestoreRef(to: .users)
                .document(uid)
                .collection(userCollection.rawValue)
                .getDocuments { [weak self] (snapshot, error) in
                    
                    guard let strongSelf = self, let documents = snapshot?.documents else {
                        
                        guard let error = error else { return }
                        
                        print("Error fetching document: \(error)")
                        
                        return
                }
                
                strongSelf.likedDiscountIds = documents.compactMap({ $0[DataKey.discountId.rawValue] as? String })
                
                completion(strongSelf.likedDiscountIds)
                    
            }
            
            
        case .collectedCards:
            
            if collectedCardIds.count > 0 {
                
                completion(collectedCardIds)
                
                return
            }
            
            firestoreRef(to: .users)
                .document(uid)
                .collection(userCollection.rawValue)
                .getDocuments { [weak self] (snapshot, error) in
                    
                    guard let strongSelf = self, let documents = snapshot?.documents else {
                        
                        guard let error = error else { return }
                        
                        print("Error fetching document: \(error)")
                        
                        return
                }
                    
                strongSelf.collectedCardIds = documents.compactMap({ $0[DataKey.cardId.rawValue] as? String })
                
                completion(strongSelf.collectedCardIds)
            }
            
        case .myCards:
            
            if myCardIds.count > 0 {
                
                completion(myCardIds)
                
                return
            }
                    
            firestoreRef(to: .users)
            .document(uid)
            .collection(userCollection.rawValue)
            .getDocuments { [weak self] (snapshot, error) in
            
            guard let strongSelf = self, let documents = snapshot?.documents else {
            
            guard let error = error else { return }
            
            print("Error fetching document: \(error)")
            
            return
            }
                
            strongSelf.myCardIds = documents.compactMap({ $0[DataKey.cardId.rawValue] as? String })
            
            completion(strongSelf.myCardIds)
            }
        }

    }
    
    func addLikedDiscountByArray(uid: String, discountIdArray: [String]) {
        
        discountIdArray.forEach { (discountId) in
            
            firestoreRef(to: .users).document(uid)
                .collection(UserCollection.likedDiscounts.rawValue)
                .addDocument(data: [
                    DataKey.discountId.rawValue: "\(discountId)"
                    ])
        }
    }
    
    func deleteLikedDiscountByArray(uid: String, discountIdArray: [String]) {
        
        discountIdArray.forEach { (discountId) in
            
            firestoreRef(to: .users).document(uid)
                .collection(UserCollection.likedDiscounts.rawValue)
                .whereField(DataKey.discountId.rawValue, isEqualTo: discountId)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        querySnapshot!.documents.forEach({ [weak self] (document) in
                            
                            // document.documentID
                            // 用 documentID 去刪除 document
                            
                            self?.firestoreRef(to: .users)
                                .document(uid).collection(UserCollection.likedDiscounts.rawValue)
                                .document(document.documentID).delete()
                        })
                    }
            }
        }
    }
    
    func addByArray(userCollection: UserCollection, uid: String, idArray: [String]) {
        
        idArray.forEach { (id) in
            
            switch userCollection {
                
            case .collectedCards, .myCards:
                
                firestoreRef(to: .users).document(uid)
                    .collection(userCollection.rawValue)
                    .addDocument(data: [
                        DataKey.cardId.rawValue: "\(id)"
                        ])
                
            case .likedDiscounts:
                
                firestoreRef(to: .users).document(uid)
                    .collection(userCollection.rawValue)
                    .addDocument(data: [
                        DataKey.discountId.rawValue: "\(id)"
                        ])
            }
        }
    }
    
    func deleteByArray(userCollection: UserCollection, uid: String, idArray: [String]) {
        
        idArray.forEach { (id) in
            
            switch userCollection {
                
            case .collectedCards, .myCards:
                
                firestoreRef(to: .users).document(uid)
                    .collection(userCollection.rawValue)
                    .whereField(DataKey.cardId.rawValue, isEqualTo: id)
                    .addSnapshotListener { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                            
                            querySnapshot!.documents.forEach({ [weak self] (document) in
                                
                                // document.documentID
                                // 用 documentID 去刪除 document
                                
                                self?.firestoreRef(to: .users)
                                    .document(uid).collection(userCollection.rawValue)
                                    .document(document.documentID).delete()
                            })
                    }
                }
                
            case .likedDiscounts:
                
                firestoreRef(to: .users).document(uid)
                    .collection(userCollection.rawValue)
                    .whereField(DataKey.discountId.rawValue, isEqualTo: id)
                    .getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                            
                            querySnapshot!.documents.forEach({ [weak self] (document) in
                                
                                // document.documentID
                                // 用 documentID 去刪除 document
                                
                                self?.firestoreRef(to: .users)
                                    .document(uid).collection(userCollection.rawValue)
                                    .document(document.documentID).delete()
                            })
                    }
                }
            }
        }
    }
    
    func addInterestedCardByArray() {
        
        
    }
    
    func checkUserSignnedIn() {
        
        if Auth.auth().currentUser == nil {
            
            // TODO: show alert 然後提供註冊登入選項，個別導到頁面
        }
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
