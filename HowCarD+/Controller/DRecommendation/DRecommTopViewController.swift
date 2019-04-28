//
//  DRecommTopViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommTopViewController: HCBaseViewController {
    
    var touchHandler: (() -> Void)?

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

extension DRecommTopViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        touchHandler?()
    }
}

extension DRecommTopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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

        newInfoCell.layoutCell()

        return newInfoCell
    }

}
