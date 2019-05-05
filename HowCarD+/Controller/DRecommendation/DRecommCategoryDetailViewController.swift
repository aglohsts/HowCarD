//
//  DRecommCategoryDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/23.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class DRecommCategoryDetailViewController: HCBaseViewController {
    
    private struct Segue {
        
        static let categoryToDiscountDetail = "CategoryToDiscountDetail"
    }
    
    var dRecommSections: DRecommSections? {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.categoryLabel.text = self.dRecommSections?.categoryTitle
                
                self.tableView.reloadData()
            }
        }
    }
    
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
        
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayEFF2F4)
        
        backView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayEFF2F4)
    }
}

extension DRecommCategoryDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.categoryToDiscountDetail {
            
            guard let discountDetailVC = segue.destination as? DiscountDetailViewController,
                let id = sender as? String else {
                    return
            }
            
            discountDetailVC.discountId = id
        }
    }
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(identifier: String(describing: DRecommCategoryHeaderView.self), bundle: nil)
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        
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
        
        headerView.layoutView(
            image: dRecommSections?.sectionContent[section].sectionImage ?? "",
            headerTitle: dRecommSections?.sectionContent[section].sectionTitle ?? "")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let headerView = view as? DRecommCategoryHeaderView else { return }
        
        headerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: .grayEFF2F4)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension DRecommCategoryDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dRecommSections?.sectionContent.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dRecommSections?.sectionContent[section].subCategory.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DRecommCategoryTableViewCell.self),
            for: indexPath) as? DRecommCategoryTableViewCell, let dRecommSections = dRecommSections else {
                
                return UITableViewCell()
        }
        
        cell.layoutCell(
            subCategory: dRecommSections.sectionContent[indexPath.section].subCategory,
            subTitle: dRecommSections.sectionContent[indexPath.section].subCategory[indexPath.row].subTitle
        )
        
        cell.cellTouchHandler = { [weak self] id in
            
            self?.performSegue(withIdentifier: Segue.categoryToDiscountDetail, sender: id)
        }
        
        return cell
    }
}
