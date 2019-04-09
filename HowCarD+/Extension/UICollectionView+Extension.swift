//
//  UICollectionView+Extension.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

extension UICollectionView {

    func agRegisterCellWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forCellWithReuseIdentifier: identifier)
    }

    func agRegisterHeaderWithClass(identifier: String, bundle: Bundle?, viewClass: AnyClass) {

        let nib = UINib(nibName: identifier, bundle: bundle)

//        register(nib, forSupplementaryViewOfKind: <#T##String#>, withReuseIdentifier: <#T##String#>)
//
//        register(viewClass, forSupplementaryViewOfKind: <#T##String#>, withReuseIdentifier: identifier)
    }
}
