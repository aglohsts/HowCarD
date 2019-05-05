//
//  DRecommCardTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCardTableViewCell: HCBaseTableViewCell {
    
    var tagArray = [String]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupCollectionView()
        
        setViewBackground(hex: .tintBackground)
    }
    
    override func setViewBackground(hex: HCColorHex) {
        
        self.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
        
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }
}

extension DRecommCardTableViewCell {
    
    func layoutCell(image: String, cardName: String, bankName: String, tagArray: [String]) {
        
        let url = URL(string: image)!
        
        leftImageView.loadImageByURL(url, placeHolder: UIImage.asset(.Image_Placeholder))
        
        cardNameLabel.text = cardName
        
        bankNameLabel.text = bankName
        
        self.tagArray = tagArray
    }
    
    func setupCollectionView() {
        
        collectionView.agRegisterCellWithNib(identifier: String(describing: CardTagCollectionViewCell.self), bundle: nil)
    }
}

extension DRecommCardTableViewCell: UICollectionViewDelegate {
    
}

extension DRecommCardTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CardTagCollectionViewCell.self),
            for: indexPath
        )
        
        guard let tagCell = cell as? CardTagCollectionViewCell else { return cell }
        
        tagCell.layoutCell(tag: tagArray[indexPath.item])
        
        return tagCell
    }
}
