//
//  DRecommCategoryTableViewCell.swift
//  HowCarD+
//
//  Created by lohsts on 2019/5/1.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryTableViewCell: HCBaseTableViewCell {
    
    var dRecommTopObject: DRecommTopObjct?

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
    
    func layoutCell(dRecommTopObject: DRecommTopObjct) {
        self.dRecommTopObject = dRecommTopObject
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
        
        headerView.layoutView(contentTitle: dRecommTopObject?.sections[section].sectionTitle ?? "")
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DRecommCategoryDetailTableViewCell.self),
            for: indexPath) as? DRecommCategoryDetailTableViewCell else {
                
                return UITableViewCell()
        }
        
        cell.layoutCell(
            image: dRecommTopObject?.sections[indexPath.section].discountInfos[indexPath.row].image ?? "",
            title: dRecommTopObject?.sections[indexPath.section].discountInfos[indexPath.row].title ?? "",
            briefContent: dRecommTopObject?.sections[indexPath.section].discountInfos[indexPath.row].
        )
        
        return cell
    }
}
