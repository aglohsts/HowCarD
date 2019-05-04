//
//  DRecommTopViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommTopViewController: HCBaseViewController {
    
    let dRecommProvider = DRecommProvider()
    
    var touchHandler: ((String) -> Void)?
    
    var dRecommTops: [DRecommTopObject2] = [] {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
//        getDiscountCategory()
        
        dRecommTops = [
            DRecommTopObject2(categoryTitle: "超商", categoryId: "cvs", image: .Icons_cvs),
            DRecommTopObject2(categoryTitle: "行動支付", categoryId: "mobilePay", image: .Icons_mobilePay),
            DRecommTopObject2(categoryTitle: "網購", categoryId: "internet", image: .Icons_internet),
            DRecommTopObject2(categoryTitle: "電影", categoryId: "movie", image: .Icons_movie),
            DRecommTopObject2(categoryTitle: "外幣消費", categoryId: "oversea", image: .Icons_oversea),
            DRecommTopObject2(categoryTitle: "加油", categoryId: "gas", image: .Icons_gas),
            DRecommTopObject2(categoryTitle: "超市", categoryId: "supermarket", image: .Icons_supermarket)
            
        ]

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
    
    func getDiscountCategory() {
        
        dRecommProvider.getDiscountCategory(completion: { [weak self] (result) in
            
            switch result {
                
            case .success(let dRecommTops):
                
                print(dRecommTops)
                
//                strongSelf.dRecommTops = dRecommTops
                
//                for index in 0 ..< strongSelf.dRecommTops.count {
//
////                    HCFirebaseManager.shared.generateURL(
////                        endPoint: .dRecommTop,
////                        path: dRecommTops[index].categoryFilePath,
////                        urlCompletion: { [weak self] url in
////
////                            dRecommTops[index].image = url
////                    })
//
//                    HCFirebaseManager.shared.getURL(urlCompletion: { (url) in
//
//                        strongSelf.dRecommTops[index].image = url
//                        })
//                }
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
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

        guard let newInfoCell = cell as? DRecommCollectionViewCell
            else { return cell }
        
        newInfoCell.layoutCell(category: dRecommTops[indexPath.item].categoryTitle, image: dRecommTops[indexPath.item].image)

//        newInfoCell.layoutCell(category: dRecommTops[indexPath.item].categoryTitle, image: imageUrl)

        return newInfoCell
    }

}
