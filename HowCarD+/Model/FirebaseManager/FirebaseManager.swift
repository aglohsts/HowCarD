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

enum FirestoreCollectionReference: String {
    case users
}

enum UserDocumentData: String {
    
    case userName
    
    case email
    
    case uid
}

enum UserCollection: String {
    
    case likedDiscounts
    
    case isReadDiscounts
    
    case collectedCards
    
    case isReadCards
    
    case myCards
}

enum MyCardCollection: String {
    
    case billInfo
}

enum UserCollectionDataKey: String {
    
    case discountId
    
    case cardId
}

enum MyCardCollectionDataKey: String {
    
    case cardNickname
    
    case needBillRemind
    
    case billDueDate
}

class HCFirebaseManager {
    
    private init() {}
    
    static let shared = HCFirebaseManager()
    
    var likedDiscountIds: [String] = []
    
    var isReadDiscountIds: [String] = []
    
    var collectedCardIds: [String] = []
    
    var myCardIds: [String] = []

    var isReadCardIds: [String] = []
    
    let group = DispatchGroup()
    
    var myCardObjects: [MyCardObject] = []
    
    func configure() {
        FirebaseApp.configure()
    }
    
    var getDocuments: (() -> [QueryDocumentSnapshot])?
    
    func firestoreRef(to collectionReference: FirestoreCollectionReference) -> CollectionReference {
        
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
    
    func addNewUser(uid: String, userName: String, email: String) {
        
        firestoreRef(to: .users).document(uid).setData([
            UserDocumentData.userName.rawValue: "\(userName)",
            UserDocumentData.uid.rawValue: "\(uid)",
            UserDocumentData.email.rawValue: "\(email)"
            ])
    }
    
    func addLikedDiscount(uid: String, discountId: String) {
        
        firestoreRef(to: .users).document(uid)
            .collection(UserCollection.likedDiscounts.rawValue)
            .addDocument(data: [
                UserCollectionDataKey.discountId.rawValue: "\(discountId)"
                ])
    }
    
    func deleteLikedDiscount(uid: String, discountId: String) {
        
        firestoreRef(to: .users).document(uid)
            .collection(UserCollection.likedDiscounts.rawValue)
            .whereField(UserCollectionDataKey.discountId.rawValue, isEqualTo: discountId)
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
    
    func addId(userCollection: UserCollection, uid: String, id: String, addIdCompletionHandler: ((Error?) -> Void)?) {
        
        switch userCollection {
            
        case .likedDiscounts:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(
                    data: [
                    UserCollectionDataKey.discountId.rawValue: "\(id)"
                    ],
                    completion: addIdCompletionHandler)
            likedDiscountIds.append(id)
            
        case .isReadDiscounts:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(
                    data: [
                    UserCollectionDataKey.discountId.rawValue: "\(id)"
                    ],
                    completion: addIdCompletionHandler)
            isReadDiscountIds.append(id)
            
        case .collectedCards:
        
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(
                    data: [
                    UserCollectionDataKey.cardId.rawValue: "\(id)"
                    ],
                    completion: addIdCompletionHandler)
            collectedCardIds.append(id)
        
        case .myCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(
                    data: [
                        UserCollectionDataKey.cardId.rawValue: "\(id)"
                    ],
                    completion: addIdCompletionHandler)
            myCardIds.append(id)
            
        case .isReadCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .addDocument(data: [
                    UserCollectionDataKey.cardId.rawValue: "\(id)"
                    ])
            isReadCardIds.append(id)
        }
    }
    
// swiftlint:disable cyclomatic_complexity
    func deleteId(userCollection: UserCollection, uid: String, id: String, completion: ((Result<Void>) -> Void)? = nil) {
        
        switch userCollection {
            
        case .likedDiscounts:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(UserCollectionDataKey.discountId.rawValue, isEqualTo: id)
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
            
        case .isReadDiscounts:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(UserCollectionDataKey.discountId.rawValue, isEqualTo: id)
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
            
            guard let index = isReadDiscountIds.firstIndex(of: id) else { return }
            
            isReadDiscountIds.remove(at: index)
            
        case .collectedCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        querySnapshot!.documents.forEach({ [weak self] (document) in
                            // 用 documentID 去刪除 document
                            
                            // 刪除文件
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
                .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        querySnapshot!.documents.forEach({ [weak self] (document) in
                            
                            // 刪除文件下的 collection
                            // 刪不掉
                            // 結果發現 Firebase 說 Swift 不能刪 collection
                            if let billInfoDocumentId =
                                self?.firestoreRef(to: .users)
                                    .document(uid)
                                    .collection(userCollection.rawValue)
                                    .document(document.documentID)
                                    .collection(MyCardCollection.billInfo.rawValue)
                                    .document().documentID {
                                
                                print(billInfoDocumentId)
                                
                                self?.firestoreRef(to: .users)
                                    .document(uid)
                                    .collection(userCollection.rawValue)
                                    .document(document.documentID)
                                    .collection(MyCardCollection.billInfo.rawValue)
                                    .document(billInfoDocumentId).delete()
                            }
                            
                            
                            // 用 documentID 去刪除 document
                            self?.firestoreRef(to: .users)
                                .document(uid).collection(userCollection.rawValue)
                                .document(document.documentID).delete()
                        })
                    }
                    
                    completion?(Result.success(()))
            }
            
            guard let index = myCardIds.firstIndex(of: id) else { return }
            
            myCardIds.remove(at: index)
            
        case .isReadCards:
            
            firestoreRef(to: .users).document(uid)
                .collection(userCollection.rawValue)
                .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
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
            
            guard let index = isReadCardIds.firstIndex(of: id) else { return }
            
            isReadCardIds.remove(at: index)
        }
    }
// swiftlint:enable cyclomatic_complexity
    
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
                
                strongSelf.likedDiscountIds = documents.compactMap({ $0[UserCollectionDataKey.discountId.rawValue] as? String })
                
                completion(strongSelf.likedDiscountIds)
            }
        case .isReadDiscounts:
            
            if isReadDiscountIds.count > 0 {
                
                completion(isReadDiscountIds)
                
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
                    
                    strongSelf.isReadDiscountIds = documents.compactMap({ $0[UserCollectionDataKey.discountId.rawValue] as? String })
                    
                completion(strongSelf.isReadDiscountIds)
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
                    
                strongSelf.collectedCardIds = documents.compactMap({ $0[UserCollectionDataKey.cardId.rawValue] as? String })
                
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
                
                strongSelf.myCardIds = documents.compactMap({ $0[UserCollectionDataKey.cardId.rawValue] as? String })
                
                completion(strongSelf.myCardIds)
            }
        case .isReadCards:
            
            if isReadCardIds.count > 0 {
                
                completion(isReadCardIds)
                
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
                    
                    strongSelf.isReadCardIds = documents.compactMap({ $0[UserCollectionDataKey.cardId.rawValue] as? String })
                    
                    completion(strongSelf.isReadCardIds)
            }
        }
    }
}
