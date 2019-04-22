//
//  FilterViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class FilterViewController: HCBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }

    var isSelected: Bool = false
    
    var selectedArray: [IndexPath] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()

        setupCollectionView()

    }

    private func setupCollectionView() {

        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.allowsMultipleSelection = true
    }

    @IBAction func onDoneSelect(_ sender: Any) {

        if (self.presentingViewController) != nil {
            dismiss(animated: true, completion: nil)
        }
    }

}

// Nav Bar
extension FilterViewController {

    private func setNavBar() {

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Dismiss),
            style: .plain,
            target: self,
            action: #selector(dismissSelf))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_ResetSelect),
            style: .plain,
            target: self,
            action: #selector(resetSelect))

    }

    @objc private func dismissSelf() {

        if (self.presentingViewController) != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func resetSelect() {
    }
    
    func handleMultipleSelection(collectionView: UICollectionView, cell: UICollectionView, indexPath: IndexPath) {
        
//        if selectedArray.count > 0 {
//            
//            selectedArray.forEach { (selectedPath) in
//                <#code#>
//            }
//        }
    }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {

        if indexPath.section == 0 {
            return CGSize(width: UIScreen.width / 4 - 19, height: 105.0)
        } else {
            return CGSize(width: UIScreen.width / 3 - 20, height: 49.0)
        }

    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
    -> UIEdgeInsets {

        return UIEdgeInsets(top: 24.0, left: 15, bottom: 0, right: 15)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat {

        return 15.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {

        return 15.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int)
    -> CGSize {

        return CGSize(width: UIScreen.width, height: 25.0)
    }
}

extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        
    }
}

extension FilterViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: FilterIconCollectionViewCell.self),
                for: indexPath
            )

            guard let choiceCell = cell as? FilterIconCollectionViewCell else { return cell }

            choiceCell.layoutCell(iconImage: UIImage.asset(.Image_Placeholder2) ?? UIImage(), choiceTitle: "123")

            return choiceCell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: FilterTextCollectionViewCell.self),
                for: indexPath
            )

            guard let choiceCell = cell as? FilterTextCollectionViewCell else { return cell }

            choiceCell.layoutCell(choiceTitle: "456")

            return choiceCell
        }

    }
}
