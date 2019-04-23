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
    
    var discountId: String = ""
    
    let discountProvider = DiscountProvider()
    
    var discountDetail: DiscountDetail? {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
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
            identifier: String(describing: HCTableViewSectionHeaderView.self),
            bundle: nil
        )
        
        tableView.separatorStyle = .none
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        self.tableView.estimatedSectionHeaderHeight = 200
        
    }
    
    private func layoutTopView(title: String, bankName: String, cardName: String, timePeriod: String, image: String) {
        
        let url = URL(string: image)!
        
        imageView.loadImageByURL(url, placeHolder: UIImage.asset(.Image_Placeholder))

        titleLabel.text = title
        
        targetLabel.text = "\(bankName) \(cardName)"
        
        timePeriodLabel.text = timePeriod
    }
    
    func getDetail() {
        
        discountProvider.getDetail(id: discountId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let discountDetail):
                
                print(discountDetail)
                
                self?.discountDetail = discountDetail
                
                DispatchQueue.main.async {
                    
                    self?.layoutTopView(
                        title: discountDetail.info.title,
                        bankName: discountDetail.info.bankName,
                        cardName: discountDetail.info.cardName,
                        timePeriod: discountDetail.info.timePeriod,
                        image: discountDetail.info.image
                    )
                }

            case .failure(let error):
                
                print(error)
            }
        })
    }
}

extension DiscountDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: HCTableViewSectionHeaderView.self)
        )
        
        guard let headerView = view as? HCTableViewSectionHeaderView,
            let discountDetail = discountDetail else { return view }
        
        headerView.layoutView(contentTitle: discountDetail.detailContent[section].briefContent)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? HCTableViewSectionHeaderView else { return }
        
        headerView.contentView.backgroundColor = UIColor.white
    }
}

extension DiscountDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return discountDetail?.detailContent.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DiscountDetailContentTableViewCell.self),
            for: indexPath
        )
        
        guard let contentCell = cell as? DiscountDetailContentTableViewCell, let discountDetail = discountDetail else {
            
            return cell
        }
        
        contentCell.layoutCell(content: discountDetail.detailContent[indexPath.row].detailContent)
        
        return contentCell
    }
}
