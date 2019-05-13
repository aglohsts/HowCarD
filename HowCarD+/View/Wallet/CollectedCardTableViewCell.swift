//
//  CollectedCardTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/27.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CollectedCardTableViewCell: HCBaseTableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        
        didSet {
            
            tagCollectionView.delegate = self
            
            tagCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var isDeleting: Bool = false {
        
        didSet {
            
            if isDeleting {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.deleteBtn.isHidden = false
                    self?.deleteBtn.setImage(UIImage.asset(.Icons_Delete), for: .normal)
                }
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.deleteBtn.isHidden = true
                }
            }
        }
    }
    
    var deleteDidTouchHandler: (() -> Void)?
    
    var tagArray:[String] = [] {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tagCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutCell(cardImage: String, cardName: String, bankName: String, tags: [String], isDeleting: Bool) {
        
        cardImageView.loadImage(cardImage, placeHolder: UIImage.asset(.Image_Placeholder2))
        
        cardNameLabel.text = cardName
        
        bankNameLabel.text = bankName
        
        self.tagArray = tags
        
        self.isDeleting = isDeleting
    }
    
    private func setupCollectionView() {
        
        tagCollectionView.agRegisterCellWithNib(
            identifier: String(describing: CardTagCollectionViewCell.self),
            bundle: nil
        )
    }
    
    @IBAction func onDelete(_ sender: Any) {
        
        deleteDidTouchHandler?()
    }
}

extension CollectedCardTableViewCell: UICollectionViewDelegate {
    
}

extension CollectedCardTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CardTagCollectionViewCell.self),
            for: indexPath
        )
        
        guard let tagCell = cell as? CardTagCollectionViewCell else { return cell }
        
        tagCell.layoutCell(tag: tagArray[indexPath.item])
        
        return tagCell
    }
}
