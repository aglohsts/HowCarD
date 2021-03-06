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
    
    let group = DispatchGroup()
    
    var likedDiscountId = [String]() {
        
        didSet {
            
            likedDiscountId = HCFirebaseManager.shared.likedDiscountIds
            
        }
    }
    
    var discountId: String = ""
    
    let discountProvider = DiscountProvider()
    
    var discountDetail: DiscountDetail? {
        
        didSet {
            
            if discountDetail != nil {
                isLiked = discountDetail!.info.isLiked
            }
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
            }
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.likeButton.setImage(UIImage.asset(.Icons_Heart_Selected), for: .normal)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.likeButton.setImage(UIImage.asset(.Icons_Heart_Normal), for: .normal)
                }
            } 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColor()
        
        setupTableView()
        
        getData()
        
        discountAddObserver()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        
        tableView.backgroundColor = .hexStringToUIColor(hex: hex)
    }
    
    @IBAction func onLikeDiscount(_ sender: Any) {
    
        if HCFirebaseManager.shared.agAuth().currentUser != nil {
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
            
            if self.discountDetail != nil {
                
                if self.discountDetail!.info.isLiked {
                    
                    HCFirebaseManager.shared.deleteId(
                        viewController: self,
                        userCollection: .likedDiscounts,
                        uid: user.uid,
                        id: self.discountDetail!.info.discountId,
                        loadingAnimation: self.startLoadingAnimation(viewController:),
                        completion: { result in
                            
                            switch result {
                                
                            case .success:
                                
                                self.discountDetail!.info.isLiked = !self.discountDetail!.info.isLiked
                                
                                NotificationCenter.default.post(
                                    name: Notification.Name(rawValue: NotificationNames.updateLikedDiscount.rawValue),
                                    object: nil
                                )
                                
                            case .failure: break
                            }
                            
                    })
                } else {
                    
                    HCFirebaseManager.shared.addId(
                        viewController: self,
                        userCollection: .likedDiscounts,
                        uid: user.uid,
                        id: self.discountDetail!.info.discountId,
                        loadingAnimation: self.startLoadingAnimation(viewController:),
                        addIdCompletionHandler: { _ in
                            
                            self.discountDetail!.info.isLiked = !self.discountDetail!.info.isLiked
                            
                            NotificationCenter.default.post(
                                name: Notification.Name(rawValue: NotificationNames.updateLikedDiscount.rawValue),
                                object: nil
                            )
                    })
                }
            }
            
        } else {
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                let navVC = UINavigationController(rootViewController: authVC)
                
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
}

extension DiscountDetailViewController {
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: HCTableViewSectionHeaderView.self),
            bundle: nil
        )
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        self.tableView.estimatedSectionHeaderHeight = 200
        
        imageView.roundCorners(
            [.layerMinXMaxYCorner],
            radius: 30.0)
        
        titleLabel.text = ""
        
        targetLabel.text = ""
        
        timePeriodLabel.text = ""
    }
    
    private func layoutTopView(title: String, bankName: String, cardName: String, timePeriod: String, image: String) {
        
        let url = URL(string: image)!
        
        imageView.loadImageByURL(url, placeHolder: UIImage.asset(.Image_Placeholder))

        titleLabel.text = title
        
        targetLabel.text = "\(bankName) \(cardName)"
        
        timePeriodLabel.text = timePeriod
    }
    
    func getData() {
        
        getDetail()
        getUserLikedDiscountId()
        
        group.notify(queue: .main, execute: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.discountDetail != nil {
                
                strongSelf.likedDiscountId.forEach({ (id) in
 
                    if strongSelf.discountDetail!.info.discountId == id {
                        
                        strongSelf.discountDetail!.info.isLiked = true
                    }
                })
            }
            
            DispatchQueue.main.async { 
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    func getDetail() {
        
        group.enter()
        
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
            
            self?.group.leave()
        })
    }
    
    func getUserLikedDiscountId() {
        
        guard let user = HCFirebaseManager.shared.agAuth().currentUser else { return }
        
        group.enter()
        
        HCFirebaseManager.shared.getId(uid: user.uid, userCollection: .likedDiscounts, completion: { [weak self] ids in
            
            self?.likedDiscountId = ids
            
            self?.group.leave()
        })
    }
    
    func discountAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateLikedDiscount),
                name: NSNotification.Name(NotificationNames.updateLikedDiscount.rawValue),
                object: nil
        )
    }
    
    @objc func updateLikedDiscount() {
        
        likedDiscountId = HCFirebaseManager.shared.likedDiscountIds
        
        discountDetail?.info.isLiked = false
        
        likedDiscountId.forEach({ (id) in
            
            if discountDetail?.info.discountId == id {
                
                discountDetail?.info.isLiked = true
            } else {
                
                discountDetail?.info.isLiked = false
            }
        })
        
        tableView.reloadData()
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
        
        headerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: .viewBackground)
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
