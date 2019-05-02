//
//  DRecommCategoryTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/1.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryTableViewCell: HCBaseTableViewCell {
    
    var dRecommSection: DRecommSectionContent? {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    var subCategory: [DRecommSubCategory] = [] {
        
        didSet {
            
            DispatchQueue.main.async {

                self.tableView.reloadData()
            }
        }
    }
    
    var subTitle: String = ""

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            tableView.delegate = self
            
            tableView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupTableView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutCell(subCategory: [DRecommSubCategory], subTitle: String) {

        self.subCategory = subCategory
        
        self.subTitle = subTitle
    }

}

// inner tableView
extension DRecommCategoryTableViewCell {
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: HCTableViewSectionHeaderView.self),
            bundle: nil
        )
        
        tableView.estimatedRowHeight = 100
        
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension DRecommCategoryTableViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: HCTableViewSectionHeaderView.self)
        )
        
        guard let headerView = view as? HCTableViewSectionHeaderView else { return view }
        
        headerView.layoutView(contentTitle: subTitle)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? HCTableViewSectionHeaderView else { return }
        
        // TODO: background color
        
//        headerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayDCDCDC)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
}

extension DRecommCategoryTableViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategory[section].subContent.discountInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DRecommCategoryDetailTableViewCell.self),
            for: indexPath) as? DRecommCategoryDetailTableViewCell else {
                
                return UITableViewCell()
        }
        
        cell.layoutCell(
            image: subCategory[indexPath.section].subContent.discountInfos[indexPath.row].image,
            title: subCategory[indexPath.section].subContent.discountInfos[indexPath.row].cardName,
            briefContent: subCategory[indexPath.section].subContent.discountInfos[indexPath.row].title
        )
        
        return cell
    }
}
