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
                    MyCardCollectionDataKey.cardNickName.rawValue: nickname,
                    MyCardCollectionDataKey.needBillRemind.rawValue: needBillRemind,
                    MyCardCollectionDataKey.billDueDate.rawValue: billDueDate
                    ])
        
    }
    
    func setMyCard(uid: String, id: String, nickname: String?, needBillRemind: Bool, billDueDate: Int?) {
        
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
        }
    }
    
    func getMyCardInfo(uid: String, userCollection: UserCollection = .myCards, id: String) {
        // TODO
        if userCollection == .myCards {
            
            firestoreRef(to: .users)
                .document(uid)
                .collection(userCollection.rawValue)
                .whereField(UserCollectionDataKey.cardId.rawValue, isEqualTo: id)
                
                
                .getDocuments { [weak self] (snapshot, error) in
                    
                    guard let strongSelf = self, let documents = snapshot?.documents else {
                        
                        guard let error = error else { return }
                        
                        print("Error fetching document: \(error)")
                        
                        return
                    }
                    
                    
                    
                    strongSelf.likedDiscountIds = documents.compactMap({ $0[UserCollectionDataKey.discountId.rawValue] as? String })
            }
            
        }
    
            
        
        
    }
}
