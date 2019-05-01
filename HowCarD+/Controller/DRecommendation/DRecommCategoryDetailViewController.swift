//
//  DRecommCategoryDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryDetailViewController: HCBaseViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    @IBAction func onDismiss(_ sender: Any) {
        
        self.willMove(toParent: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParent()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC)
        
        backView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC)
    }
}

extension DRecommCategoryDetailViewController {
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(identifier: String(describing: DRecommCategoryHeaderView.self), bundle: nil)
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        
//        tableView.estimatedRowHeight = 100
        
//        tableView.rowHeight = UITableView.automaticDimension
        
        categoryLabel.text = ""
    }
}

extension DRecommCategoryDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DRecommCategoryHeaderView.self)
        )
        
        guard let headerView = view as? DRecommCategoryHeaderView else { return view }
        
        let url = "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/21/27/4f/21274f72-38eb-c0f1-0c76-685e5666eff5/AppIcon-0-1x_U007emarketing-0-0-85-220-0-5.png/246x0w.jpg"
        
        headerView.layoutView(image: url, headerTitle: "711")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? DRecommCategoryHeaderView else { return }
        
        headerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
        // TODO: auto dimension
    }
}

extension DRecommCategoryDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DRecommCategoryTableViewCell.self),
            for: indexPath) as? DRecommCategoryTableViewCell else {
                
                return UITableViewCell()
        }
        
        return cell
    }
}
