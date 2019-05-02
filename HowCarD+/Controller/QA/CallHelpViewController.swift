//
//  CallHelpViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CallHelpViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension CallHelpViewController: UITableViewDelegate {
    
    
}

extension CallHelpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CallHelpTableViewCell.self),
            for: indexPath
        )
        
        guard let likedDiscountCell = cell as? CallHelpTableViewCell else { return cell }
        
        return UITableViewCell()
    }
    
    
}
