//
//  FirebaseManager+Extension.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import NVActivityIndicatorView

enum HCFirebaseStorageEndpoint: String {
    
    case dRecommTop = "dRecomm/top"
}

extension HCFirebaseManager {
    
    func storageRef() -> StorageReference {
        
        return Storage.storage().reference()
    }
    
    func generateURL(endPoint: HCFirebaseStorageEndpoint, path: String, urlCompletion: @escaping ((URL) -> Void)) {
  
        storageRef().child("dRecomm/top/Icons_cvs.png").downloadURL(completion: { (url, error) in
            
            //\(endPoint.rawValue)\(path)
            print(url)
            if let error = error {
                
                print(error.localizedDescription)
            }
            
            guard let url = url else { return }
            
            urlCompletion(url)
            })
    }
    
    func getURL(urlCompletion: @escaping ((URL) -> Void)) {
        
        storageRef().child("dRecomm/top/Icons_cvs.png").downloadURL(completion: { (url, error) in
            
            print(url)
            
            guard let url = url else { return }
            
            urlCompletion(url)
            
        })
    }
    
    func checkUserSignnedIn(viewController: UIViewController, checkedSignnedInCompletionHandler: (() -> Void)?) {
        
        if HCFirebaseManager.shared.agAuth().currentUser != nil {
            
            checkedSignnedInCompletionHandler?()
            
        } else {
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                let navVC = UINavigationController(rootViewController: authVC)
                
                viewController.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func addMyCardInfo(uid: String, id: String, nickname: String?, needBillRemind: Bool, billDueDate: Int?, documentID: String) {
        
        let newDocumentId = UUID().uuidString
        
            firestoreRef(to: .users)
                .document(uid)
                .collection(UserCollection.myCards.rawValue)
                .document(documentID)
                .collection(MyCardCollection.billInfo.rawValue)
                .addDocument(data: [
                    BillInfo.CodingKeys.cardNickname.rawValue: nickname,
                    BillInfo.CodingKeys.needBillRemind.rawValue: needBillRemind,
                    BillInfo.CodingKeys.billDueDate.rawValue: billDueDate
                    ])
        
    }
    
    func setMyCard(uid: String, id: String, nickname: String?, needBillRemind: Bool, billDueDate: Int?, completion: ((Result<Void>) -> Void)? = nil) {
        
        firestoreRef(to: .users).document(uid)
            .collection(UserCollection.myCards.rawValue)
            .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    
                    querySnapshot!.documents.forEach({ [weak self] (document) in
                        
                        // 用 documentID 去新增卡片資訊
                        self?.addMyCardInfo(
                            uid: uid,
                            id: id,
                            nickname: nickname,
                            needBillRemind: needBillRemind,
                            billDueDate: billDueDate,
                            documentID: document.documentID
                        )
                    })
                }
    
                completion?(Result.success(()))
        }
    }
    
    func getMyCardInfo(uid: String, userCollection: UserCollection = .myCards, completion: @escaping ([MyCardObject]) -> Void) {

        myCardObjects = []
        
        if userCollection == .myCards {
            
            getId(uid: uid, userCollection: .myCards, completion: { [weak self] (myCardIds) in
                
                guard let strongSelf = self else { return }
                
                myCardIds.forEach { [weak self] (id) in
                    
                    strongSelf.group.enter()
                    
                    strongSelf.firestoreRef(to: .users).document(uid)
                        .collection(userCollection.rawValue)
                        .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
                        .getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                }
                                
                                querySnapshot!.documents.forEach({ [weak self] (document) in
                                    
                                    strongSelf.group.enter()
                                    
                                    strongSelf.firestoreRef(to: .users)
                                        .document(uid)
                                        .collection(userCollection.rawValue)
                                        .document(document.documentID)
                                        .collection(MyCardCollection.billInfo.rawValue)
                                        .getDocuments(completion: { (querySnapshot, _) in
                                            
                                            let decoder = JSONDecoder()
                                            
                                            querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                                                
                                                if let jsonData = try? JSONSerialization.data(
                                                    withJSONObject: queryDocumentSnapshot.data()
                                                    ) {
                                                    if let info = try? decoder.decode(BillInfo.self, from: jsonData) {
                                                        
                                                        strongSelf.myCardObjects.append(MyCardObject(cardId: id, billInfo: info))
                                                        
                                                    }
                                                }
                                                
                                            })
                                            
                                            strongSelf.group.leave()
                                            
                                        })
                                })
                                
                                strongSelf.group.leave()
                            }
                    }
                }
                strongSelf.group.notify(queue: .global(), execute: {
                    
                    completion(strongSelf.myCardObjects)
                })
            })
        }
    }
    
    func updateMyCardInfo(userCollection: UserCollection = .myCards, uid: String, id: String, updatedObject: MyCardObject) {
        
        firestoreRef(to: .users).document(uid)
            .collection(userCollection.rawValue)
            .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    
                    
                    querySnapshot!.documents.forEach({ [weak self] (document) in
                        
                        guard let strongSelf = self else { return }
                        
                        // 拿id
                        strongSelf.firestoreRef(to: .users)
                            .document(uid)
                            .collection(userCollection.rawValue)
                            .document(document.documentID)
                            .collection(MyCardCollection.billInfo.rawValue)
                            .getDocuments(completion: { (querySnapshot, error) in
                                
                                // 用 id 更新 billInfo
                                querySnapshot?.documents.forEach({ (queryDocumentSnapshot) in
                                    
                                    strongSelf.firestoreRef(to: .users)
                                        .document(uid)
                                        .collection(userCollection.rawValue)
                                        .document(document.documentID)
                                        .collection(MyCardCollection.billInfo.rawValue)
                                        .document(queryDocumentSnapshot.documentID)
                                        .updateData([
                                            BillInfo.CodingKeys.cardNickname.rawValue: updatedObject.billInfo.cardNickname,
                                            BillInfo.CodingKeys.needBillRemind.rawValue: updatedObject.billInfo.needBillRemind,
                                            BillInfo.CodingKeys.billDueDate.rawValue: updatedObject.billInfo.billDueDate
                                        ])
                                })
                            })
                    })
                }
            }
        
    }
    
    
}
