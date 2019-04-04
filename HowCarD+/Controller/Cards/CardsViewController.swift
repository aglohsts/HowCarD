//
//  CardsViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardsViewController: HCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
    }
    
    private func setNavBar(){
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter_Normal), style: .plain, target: self, action: #selector(showFilter))
        
    }
    
    @objc func showFilter() {
        
        if let filterVC = UIStoryboard(name: StoryboardCategory.filter, bundle: nil).instantiateViewController(withIdentifier: String(describing: FilterViewController.self)) as? FilterViewController
        {
            let navVC = UINavigationController(rootViewController: filterVC)
            
            self.present(navVC, animated:true, completion: nil)
        }
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
