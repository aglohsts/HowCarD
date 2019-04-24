//
//  CardInfoTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/5.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardInfoTableViewCell: UITableViewCell {
    
    var collectButtonDidTouchHandler: (() -> Void)?

    var tagArray = [String]() {
        
        didSet {
            self.tagCollectionView.reloadData()
        }
    }

    var isRead: Bool = false {
        didSet {
            if isRead {
                backView.layer.backgroundColor = UIColor.lightGray.cgColor

            } else {
                backView.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    var isCollected: Bool = false {
        
        didSet {
            
            if isCollected {
                
                //                collectedBtn.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
                
                collectedBtn.setTitle("V", for: .normal)
            } else {
                
                //                collectedBtn.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
                
                collectedBtn.setTitle("X", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var collectedBtn: UIButton!

    @IBOutlet weak var backView: UIView!

//    @IBOutlet weak var bankIconImageView: UIImageView!

    @IBOutlet weak var bankNameLabel: UILabel!

    @IBOutlet weak var cardImageView: UIImageView!

    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.delegate = self

            tagCollectionView.dataSource = self
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func layoutCell(
        tableViewCellIsTapped: Bool,
        isCollected: Bool,
        bankName: String,
        cardName: String,
        cardImage: String,
        tags: [String]
        ) {

        isRead = tableViewCellIsTapped

        self.isCollected = isCollected

//        bankIconImageView.image = bankIcon

        bankNameLabel.text = bankName
        
        cardNameLabel.text = cardName

        cardImageView.loadImage(cardImage)
        
        self.tagArray = tags

    }

    func setupCollectionView() {
        
        tagCollectionView.agRegisterCellWithNib(
            identifier: String(describing: CardTagCollectionViewCell.self),
            bundle: nil
        )
    }
    
    @IBAction func onCollectCard(_ sender: Any) {
        
        collectButtonDidTouchHandler?()
    }
    
}

extension CardInfoTableViewCell: UICollectionViewDelegate {

}

extension CardInfoTableViewCell: UICollectionViewDataSource {
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
