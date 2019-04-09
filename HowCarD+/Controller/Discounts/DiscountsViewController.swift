//
//  DiscountsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountsViewController: HCBaseViewController {

    var isFiltered: Bool = false

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

        collectionView.agRegisterCellWithNib(
            identifier: String(describing: DiscountCollectionViewCell.self),
            bundle: nil)

//        collectionView.register(
//            DiscountHeaderCollectionReusableView.self,
//            forSupplementaryViewOfKind: String(describing: DiscountHeaderCollectionReusableView.self),
//            withReuseIdentifier: String(describing: DiscountHeaderCollectionReusableView.self)
//        )

        let nib = UINib(nibName: String(describing: DiscountHeaderCollectionReusableView.self), bundle: nil)

        collectionView.register(
            nib,
            forSupplementaryViewOfKind: String(describing: DiscountHeaderCollectionReusableView.self),
            withReuseIdentifier: String(describing: DiscountHeaderCollectionReusableView.self)
        )

    }

}

extension DiscountsViewController: UICollectionViewDelegate {

}

extension DiscountsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    // Section Header

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath)
    -> UICollectionReusableView {

//        let view = collectionView.dequeueReusableSupplementaryView(
//        ofKind: String(describing: DiscountHeaderCollectionReusableView.self),
//        withReuseIdentifier: String(describing: DiscountHeaderCollectionReusableView.self),
//        for: indexPath
//        )
//
//        guard let headerView = view as? DiscountHeaderCollectionReusableView else { return view }
//
//        headerView.layoutView(category: "銀行")
//
//        return headerView
        return UICollectionReusableView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath) {
        guard let headerView = view as? DiscountHeaderCollectionReusableView else { return }

        headerView.backgroundColor = .blue
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DiscountCollectionViewCell.self),
            for: indexPath
        )

        guard let discountCell = cell as? DiscountCollectionViewCell else { return cell }

        discountCell.layoutCell(
            image: UIImage.asset(.Image_Placeholder) ?? UIImage(),
            discountName: "123",
            target: "OO銀行 XX卡",
            timePeriod: 1577836799
        )

        return discountCell
    }

}
