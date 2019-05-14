//
//  MyCardViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import HFCardCollectionViewLayout

struct CardInfo {
    var color: UIColor
    var icon: UIImage
}

struct CardLayoutSetupOptions {
    var firstMovableIndex: Int = 0
    var cardHeadHeight: CGFloat = 60
    var cardShouldExpandHeadHeight: Bool = true
    var cardShouldStretchAtScrollTop: Bool = true
    var cardMaximumHeight: CGFloat = 0
    var bottomNumberOfStackedCards: Int = 5
    var bottomStackedCardsShouldScale: Bool = true
    var bottomCardLookoutMargin: CGFloat = 10
    var bottomStackedCardsMaximumScale: CGFloat = 1.0
    var bottomStackedCardsMinimumScale: CGFloat = 0.94
    var spaceAtTopForBackgroundView: CGFloat = 0
    var spaceAtTopShouldSnap: Bool = true
    var spaceAtBottom: CGFloat = 0
    var scrollAreaTop: CGFloat = 120
    var scrollAreaBottom: CGFloat = 120
    var scrollShouldSnapCardHead: Bool = false
    var scrollStopCardsAtTop: Bool = true
}

class MyCardViewController: HCBaseViewController {
    
    var myCardObjects: [MyCardObject] = []
    
    var updatedObjects:  [MyCardObject] = []
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    var cardLayoutOptions: CardLayoutSetupOptions? = CardLayoutSetupOptions()
    var shouldSetupBackgroundView = false
    
    var cardArray: [CardInfo] = []
    
    override func viewDidLoad() {
        self.setupCards()
        super.viewDidLoad()
        
        getMyCardInfo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        for object in updatedObjects {
            
            HCFirebaseManager.shared.updateMyCardInfo(
                uid: user.uid,
                id: object.cardId,
                updatedObject: object
            )
        }
    }
    
    // MARK: Actions
    
    func deleteCardAt(indexPath: IndexPath) {
//        var index = 0
//        if self.cardCollectionViewLayout!.revealedIndex >= 0 {
//            index = self.cardCollectionViewLayout!.revealedIndex
//        }
        self.cardCollectionViewLayout?.flipRevealedCardBack(completion: {
//            self.cardArray.remove(at: index)
            self.collectionView?.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
        })
    }
    
}

extension MyCardViewController {
    
    func getMyCardInfo() {
            
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }

        HCFirebaseManager.shared.getMyCardInfo(uid: user.uid, completion: { [weak self] (myCardObjects) in
            
            self?.myCardObjects = myCardObjects
            
            
            DispatchQueue.main.async { [weak self] in
                
                self?.collectionView.reloadData()
            }
            print(self?.myCardObjects)
        })
    }
}

extension MyCardViewController {
    
    // MARK: Private Functions
    
    private func setupCards() {
        if let cardCollectionViewLayout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
            self.cardCollectionViewLayout = cardCollectionViewLayout
        }
        if self.shouldSetupBackgroundView == true {
            self.setupBackgroundView()
        }
        if let cardLayoutOptions = self.cardLayoutOptions {
            self.cardCollectionViewLayout?.firstMovableIndex = cardLayoutOptions.firstMovableIndex
            self.cardCollectionViewLayout?.cardHeadHeight = cardLayoutOptions.cardHeadHeight
            self.cardCollectionViewLayout?.cardShouldExpandHeadHeight = cardLayoutOptions.cardShouldExpandHeadHeight
            self.cardCollectionViewLayout?.cardShouldStretchAtScrollTop = cardLayoutOptions.cardShouldStretchAtScrollTop
            self.cardCollectionViewLayout?.cardMaximumHeight = cardLayoutOptions.cardMaximumHeight
            self.cardCollectionViewLayout?.bottomNumberOfStackedCards = cardLayoutOptions.bottomNumberOfStackedCards
            self.cardCollectionViewLayout?.bottomStackedCardsShouldScale
                = cardLayoutOptions.bottomStackedCardsShouldScale
            self.cardCollectionViewLayout?.bottomCardLookoutMargin = cardLayoutOptions.bottomCardLookoutMargin
            self.cardCollectionViewLayout?.spaceAtTopForBackgroundView = cardLayoutOptions.spaceAtTopForBackgroundView
            self.cardCollectionViewLayout?.spaceAtTopShouldSnap = cardLayoutOptions.spaceAtTopShouldSnap
            self.cardCollectionViewLayout?.spaceAtBottom = cardLayoutOptions.spaceAtBottom
            self.cardCollectionViewLayout?.scrollAreaTop = cardLayoutOptions.scrollAreaTop
            self.cardCollectionViewLayout?.scrollAreaBottom = cardLayoutOptions.scrollAreaBottom
            self.cardCollectionViewLayout?.scrollShouldSnapCardHead = cardLayoutOptions.scrollShouldSnapCardHead
            self.cardCollectionViewLayout?.scrollStopCardsAtTop = cardLayoutOptions.scrollStopCardsAtTop
            self.cardCollectionViewLayout?.bottomStackedCardsMinimumScale
                = cardLayoutOptions.bottomStackedCardsMinimumScale
            self.cardCollectionViewLayout?.bottomStackedCardsMaximumScale
                = cardLayoutOptions.bottomStackedCardsMaximumScale
        }
        self.collectionView?.reloadData()
    }
    
    private func setupBackgroundView() {
        
        if self.cardLayoutOptions?.spaceAtTopForBackgroundView == 0 {
            
            // Height of the NavigationBar in the BackgroundView
            
            self.cardLayoutOptions?.spaceAtTopForBackgroundView = 44
        }
        
        //        if let collectionView = self.collectionView {
        //            collectionView.backgroundView = self.backgroundView
        //            self.backgroundNavigationBar?.shadowImage = UIImage()
        //            self.backgroundNavigationBar?.setBackgroundImage(UIImage(), for: .default)
        //        }
    }
    
    private func getRandomColor() -> UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
    
    // MARK: CollectionView
extension MyCardViewController: HFCardCollectionViewLayoutDelegate, UICollectionViewDataSource  {
    
    func cardCollectionViewLayout(
        _ collectionViewLayout: HFCardCollectionViewLayout,
        willRevealCardAtIndex index: Int
        ) {
        if let cell = self.collectionView?
            .cellForItem(at: IndexPath(item: index, section: 0)) as? MyCardCollectionViewCell {
            
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(true)
        }
    }
    
    func cardCollectionViewLayout(
        _ collectionViewLayout: HFCardCollectionViewLayout,
        willUnrevealCardAtIndex index: Int
        ) {
        if let cell = self.collectionView?
            .cellForItem(at: IndexPath(item: index, section: 0)) as? MyCardCollectionViewCell {
            
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.myCardObjects.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: MyCardCollectionViewCell.self),
            for: indexPath
        )
        
        guard let myCardCell = cell as? MyCardCollectionViewCell else { return cell }
        
        myCardCell.layoutCell(
            cardName: myCardObjects[indexPath.row].billInfo.cardNickname ?? "我的信用卡",
            imageIcon: "",
            myCardObject: myCardObjects[indexPath.row])
        
        myCardCell.updateMyCardInfoHandler = { [weak self] (updatedCardObject) in
            
            self?.myCardObjects[indexPath.item] = updatedCardObject
            
            self?.updatedObjects.append(updatedCardObject)
            
            print(self?.myCardObjects)
        }
        
        myCardCell.deleteDidTouchHandler = { [weak self] in
            
            guard let strongSelf = self,
                let user = HCFirebaseManager.shared.agAuth().currentUser else {
                    return
            }

            HCFirebaseManager.shared.deleteId(
                    userCollection: .myCards,
                    uid: user.uid,
                    id: strongSelf.myCardObjects[indexPath.item].cardId
            )

            strongSelf.myCardObjects.remove(at: indexPath.item)

            DispatchQueue.main.async { [weak self] in

                strongSelf.collectionView.reloadData()
            }
        }
//        walletCell.backgroundColor = self.cardArray[indexPath.item].color
//        walletCell.iconImageView?.image = self.cardArray[indexPath.item].icon
        
        return myCardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = self.cardArray[sourceIndexPath.item]
        self.cardArray.remove(at: sourceIndexPath.item)
        self.cardArray.insert(tempItem, at: destinationIndexPath.item)
    }
}
