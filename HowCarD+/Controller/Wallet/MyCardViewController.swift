//
//  MyCardViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import HFCardCollectionViewLayout

class MyCardViewController: HCBaseViewController {
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyCardViewController: HFCardCollectionViewLayoutDelegate {
    
    /// Asks if the card at the specific index can be revealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter canRevealCardAtIndex: Index of the card.
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, canRevealCardAtIndex index: Int) -> Bool {
        
        return true
    }
    
    /// Asks if the card at the specific index can be unrevealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter canUnrevealCardAtIndex: Index of the card.
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, canUnrevealCardAtIndex index: Int) -> Bool {
        
        return true
    }
    
    /// Feedback when the card at the given index will be revealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didRevealedCardAtIndex: Index of the card.
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
        
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? MyCardCollectionViewCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            //            cell.cardIsRevealed(true)
        }
    }
    
    /// Feedback when the card at the given index was revealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didRevealedCardAtIndex: Index of the card.
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, didRevealCardAtIndex index: Int) {
        
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? MyCardCollectionViewCell {
            cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            //            cell.cardIsRevealed(false)
        }
    }
    
    /// Feedback when the card at the given index will be unrevealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didUnrevealedCardAtIndex: Index of the card.
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
        
    }
    
    /// Feedback when the card at the given index was unrevealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didUnrevealedCardAtIndex: Index of the card.
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, didUnrevealCardAtIndex index: Int) {
        
    }
}

extension MyCardViewController: UICollectionViewDelegate {
    
}



extension MyCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: MyCardCollectionViewCell.self),
            for: indexPath
        )
        
        guard let walletCell = cell as? MyCardCollectionViewCell
            else { return cell }
        
        return walletCell
    }
}
