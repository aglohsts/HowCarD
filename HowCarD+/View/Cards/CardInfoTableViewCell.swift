//
//  CardInfoTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/5.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardInfoTableViewCell: UITableViewCell {

    var tagArray = ["回饋", "電影", "加油"]

    var isRead: Bool = false {
        didSet {
            if isRead {
                backView.layer.backgroundColor = UIColor.lightGray.cgColor

            } else {
                backView.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }

    var isSaved: Bool = false {
        didSet {
            if isSaved {
                bookMarkImageView.image = UIImage.asset(.Icons_Bookmark_Saved)
            } else {
                bookMarkImageView.image = UIImage.asset(.Icons_Bookmark_Normal)
            }
        }
    }

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var bookMarkImageView: UIImageView!

//    @IBOutlet weak var bankIconImageView: UIImageView!

    @IBOutlet weak var bankNameLabel: UILabel!

    @IBOutlet weak var cardImageView: UIImageView!

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
        bookMarkIsTapped: Bool,
        bankIcon: UIImage,
        bankName: String,
        cardImage: UIImage
        ) {

        isRead = tableViewCellIsTapped

        isSaved = bookMarkIsTapped

//        bankIconImageView.image = bankIcon

        bankNameLabel.text = bankName

        cardImageView.image = cardImage

    }

    func setupCollectionView() {
        tagCollectionView.agRegisterCellWithNib(
            identifier: String(describing: CardTagCollectionViewCell.self),
            bundle: nil
        )

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
