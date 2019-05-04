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
    var cardHeadHeight: CGFloat = 80
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
    
    var numberOfCards: Int = 15
}

class MyCardViewController: UIViewController, HFCardCollectionViewLayoutDelegate, UICollectionViewDataSource {
    
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
        self.setupExample()
        super.viewDidLoad()
    }
    
    // MARK: CollectionView
    
    func cardCollectionViewLayout(
        _ collectionViewLayout: HFCardCollectionViewLayout,
        willRevealCardAtIndex index: Int
        ) {
        if let cell = self.collectionView?
            .cellForItem(at: IndexPath(item: index, section: 0)) as? WalletCollectionViewCell {
            
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(true)
        }
    }
    
    func cardCollectionViewLayout(
        _ collectionViewLayout: HFCardCollectionViewLayout,
        willUnrevealCardAtIndex index: Int
        ) {
        if let cell = self.collectionView?
            .cellForItem(at: IndexPath(item: index, section: 0)) as? WalletCollectionViewCell {
            
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            cell.cardIsRevealed(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CardCell",
            for: indexPath
        )
        
        guard let walletCell = cell as? WalletCollectionViewCell else { return cell }
        
        walletCell.backgroundColor = self.cardArray[indexPath.item].color
        walletCell.imageIcon?.image = self.cardArray[indexPath.item].icon
        
        return walletCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = self.cardArray[sourceIndexPath.item]
        self.cardArray.remove(at: sourceIndexPath.item)
        self.cardArray.insert(tempItem, at: destinationIndexPath.item)
    }
    
    // MARK: Actions
    
    @IBAction func goBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardAction() {
        let index = 0
        let newItem = createCardInfo()
        self.cardArray.insert(newItem, at: index)
        self.collectionView?.insertItems(at: [IndexPath(item: index, section: 0)])
        
        if self.cardArray.count == 1 {
            self.cardCollectionViewLayout?.revealCardAt(index: index)
        }
    }
    
    @IBAction func deleteCardAtIndex0orSelected() {
        var index = 0
        if self.cardCollectionViewLayout!.revealedIndex >= 0 {
            index = self.cardCollectionViewLayout!.revealedIndex
        }
        self.cardCollectionViewLayout?.flipRevealedCardBack(completion: {
            self.cardArray.remove(at: index)
            self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        })
    }
    
    // MARK: Private Functions
    
    private func setupExample() {
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
            
            let count = cardLayoutOptions.numberOfCards
            
            for index in 0..<count {
                self.cardArray.insert(createCardInfo(), at: index)
            }
        }
        self.collectionView?.reloadData()
    }
    
    private func createCardInfo() -> CardInfo {
        let icons: [UIImage] = [#imageLiteral(resourceName: "Icons_24px_Dismiss"), #imageLiteral(resourceName: "Icons_24px_Filter_Filtered"), #imageLiteral(resourceName: "Icons_Next"), #imageLiteral(resourceName: "Icons_36px_DRec_Selected"), #imageLiteral(resourceName: "Icons_Heart_Selected"), #imageLiteral(resourceName: "Icons_36px_Wallet_Selected")]
        let icon = icons[Int(arc4random_uniform(6))]
        let newItem = CardInfo(color: self.getRandomColor(), icon: icon)
        return newItem
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


