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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        
        setupCollectionView()
        
    }
    
    private func setupCollectionView(){
        
        collectionView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func onDoneSelect(_ sender: Any) {
        
        if((self.presentingViewController) != nil){
            dismiss(animated: true, completion: nil)
        }
    }
    
}

// Nav Bar
extension FilterViewController {
    
    private func setNavBar(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Dismiss), style: .plain, target: self, action: #selector(dismissFilter))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icons_24px_ResetSelect), style: .plain, target: self, action: #selector(resetSelect))
        
    }
    
    @objc private func dismissFilter() {
        
        if((self.presentingViewController) != nil){
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func resetSelect() {
    }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.width / 3, height: 170.0)
        } else if indexPath.section == 1 {
            return CGSize(width: UIScreen.width / 2, height: 170.0)
        } else if indexPath.section == 2 {
            return CGSize(width: UIScreen.width / 4, height: 170.0)
        }
        
        return CGSize.zero
    }
}

extension FilterViewController: UICollectionViewDelegate {
    
    
}

extension FilterViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FilterIconCollectionViewCell.self),
            for: indexPath
        )
        
        guard let choiceCell = cell as? FilterIconCollectionViewCell else { return cell }
        
        choiceCell.layoutCell(iconImage: UIImage.asset(.Image_Placeholder2) ?? UIImage(), choiceTitle: "123")
        
       
        return choiceCell
    }
}
