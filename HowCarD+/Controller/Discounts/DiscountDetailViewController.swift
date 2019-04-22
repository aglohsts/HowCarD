//
//  DiscountDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DiscountDetailViewController: HCBaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    var discountId: String = "" {
        
        didSet {
            print("yo")
        }
    }
    
    let discountProvider = DiscountProvider()
    
    var discountDetail: DiscountDetail?
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage.asset(.Icons_Heart_Selected), for: .normal)
            } else {
                likeButton.setImage(UIImage.asset(.Icons_Heart_Normal), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        getDetail()
    }
}

extension DiscountDetailViewController {
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: DiscountDetailTableViewHeaderFooterView.self),
            bundle: nil
        )
        
        tableView.separatorStyle = .none
        
        imageView.image = UIImage.asset(.Image_Placeholder)
        
    }
    
    func getDetail() {
        
        discountProvider.getDetail(id: discountId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let discountDetail):
                
                print(discountDetail)
                
                self?.discountDetail = discountDetail
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
}

extension DiscountDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DiscountDetailTableViewHeaderFooterView.self)
        )
        
        guard let headerView = view as? DiscountDetailTableViewHeaderFooterView else { return view }
        
        headerView.layoutView(contentTitle: "123123")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? DiscountDetailTableViewHeaderFooterView else { return }
        
        headerView.contentView.backgroundColor = UIColor.white
    }
}

extension DiscountDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DiscountDetailContentTableViewCell.self),
            for: indexPath
        )
        
        guard let contentCell = cell as? DiscountDetailContentTableViewCell else { return cell }
        
        contentCell.layoutCell(content: "12345678")
        
        return contentCell
    }
}
