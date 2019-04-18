//
//  KingfisherWrapper.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/17.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String, placeHolder: UIImage? = nil) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    func loadImageByURL(_ url: URL, placeHolder: UIImage? = nil) {
        
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
