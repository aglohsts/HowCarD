//
//  DRecommTopViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommTopViewController: HCBaseViewController {
    
    var touchHandler: ((String) -> Void)?
    
    var dRecommTops: [DRecommTop] = [
        DRecommTop(category: "超商", categoryId: "cvs", image: UIImage.asset(.Image_Placeholder) ?? UIImage()),
        DRecommTop(category: "行動支付", categoryId: "mobilePay", image: UIImage.asset(.Image_Placeholder) ?? UIImage()),
        DRecommTop(category: "網購", categoryId: "internet", image: UIImage.asset(.Image_Placeholder) ?? UIImage()),
        DRecommTop(category: "電影", categoryId: "movie", image: UIImage.asset(.Image_Placeholder) ?? UIImage()),
        DRecommTop(category: "外幣消費", categoryId: "oversea", image: UIImage.asset(.Image_Placeholder) ?? UIImage()),
        DRecommTop(category: "加油", categoryId: "gas", image: UIImage.asset(.Image_Placeholder) ?? UIImage()),
        DRecommTop(category: "超市", categoryId: "supermarket", image: UIImage.asset(.Image_Placeholder) ?? UIImage())
    ]

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    private func setupCollectionView() {

        collectionView.showsHorizontalScrollIndicator = false
        
        setBackgroundColor()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        
        collectionView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
}

extension DRecommTopViewController {
}

extension DRecommTopViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        touchHandler?(dRecommTops[indexPath.item].categoryId)
    }
}

extension DRecommTopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dRecommTops.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DRecommCollectionViewCell.self),
            for: indexPath
        )

        guard let newInfoCell = cell as? DRecommCollectionViewCell else { return cell }

        newInfoCell.layoutCell(category: dRecommTops[indexPath.item].category, image: "")

        return newInfoCell
    }

}
