//
//  CardDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardDetailViewController: HCBaseViewController {
    
    @IBOutlet weak var topBackView: UIView!
    
    var cardID: String = ""
    
    let cardProvider = CardProvider()
    
    var isDetailAvailable: Bool = true
    
    var collectedCardIds = [String]()
    
    @IBOutlet weak var cardImageView: UIImageView! {
        
        didSet {
            
            cardImageView.image = UIImage()
        }
    }
    
    var cardCollectDidTouchHandler: (() -> Void)?
    
    var isMyCardDidTouchHandler: (() -> Void)?
    
    @IBOutlet weak var collectedBtn: UIButton!
    
    @IBOutlet weak var isMyCardBtn: UIButton!
    
    @IBOutlet weak var toOfficialWebBtn: UIButton!
    
    @IBOutlet weak var toApplyCardBtn: UIButton!
    
    var isCollected: Bool = false {
    
        didSet {
            
//            isCollected = self.cardObject?.basicInfo.isCollected ?? false

            if isCollected {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.collectedBtn.setImage(UIImage.asset(.Icons_Bookmark_Saved), for: .normal)
                }
            } else {

                DispatchQueue.main.async { [weak self] in
                    
                    self?.collectedBtn.setImage(UIImage.asset(.Icons_Bookmark_Normal), for: .normal)
                }
            }
        }
        willSet {
            
            self.cardObject?.basicInfo.isCollected = isCollected
        }
    }
    
    var isMyCard: Bool = false {
        
        didSet {
            
            if isMyCard {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.isMyCardBtn.setImage(UIImage.asset(.Icons_isMyCard_Selected), for: .normal)
                }
            } else {
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.isMyCardBtn.setImage(UIImage.asset(.Icons_isMyCard_Normal), for: .normal)
                }
            }
        }
        willSet {
            
            self.cardObject?.basicInfo.isMyCard = isMyCard
        }
    }

    @IBOutlet weak var cardNameLabel: UILabel! {
        
        didSet {
            
            cardNameLabel.text = ""
        }
    }
    
    @IBOutlet weak var bankNameLabel: UILabel! {
        
        didSet {
            
            bankNameLabel.text = ""
        }
    }
    
    var cardObject: CardObject? {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tableView.reloadData()
                
                self?.tagCollectionView.reloadData()
                
                self?.setHeaderViewContent(
                    cardName: self?.cardObject?.basicInfo.name ?? "",
                    bankName: self?.cardObject?.basicInfo.bank ?? "",
                    image: self?.cardObject?.basicInfo.image ?? ""
                )
            }
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.delegate = self

            tagCollectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()

        setupTableView()

        setupCollectionView()

//        setNavBar()
        
        getcardDetail()
        
        cardAddObserver()
    }
    
    override func setBackgroundColor(_ hex: HCColorHex = HCColorHex.viewBackground) {
        super.setBackgroundColor()
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: hex)
    }

    @objc private func onShare() {

    }
    
    @IBAction func onCollectCard(_ sender: Any) {
        
        if HCFirebaseManager.shared.agAuth().currentUser != nil {
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser, let cardObject = cardObject else { return }
            
            if isCollected {
                
                HCFirebaseManager.shared.deleteId(
                    viewController: self,
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: cardObject.basicInfo.id,
                    loadingAnimation: startLoadingAnimation(viewController:)
                )
            } else {
                
                HCFirebaseManager.shared.addId(
                    userCollection: .collectedCards,
                    uid: user.uid,
                    id: cardObject.basicInfo.id,
                    addIdCompletionHandler: nil
                )
            }
            
            isCollected = !isCollected
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: NotificationNames.updateCollectedCard.rawValue),
                object: nil
            )
            
            cardCollectDidTouchHandler?()
            
        } else {
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                let navVC = UINavigationController(rootViewController: authVC)
                
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onIsMyCardButton(_ sender: Any) {
        
        if HCFirebaseManager.shared.agAuth().currentUser != nil {
            
            guard let addMyCardVC = UIStoryboard(
                name: StoryboardCategory.cards,
                bundle: nil).instantiateViewController(
                    withIdentifier: String(describing: AddMyCardViewController.self)) as? AddMyCardViewController
                else { return }
            
            guard let user = HCFirebaseManager.shared.agAuth().currentUser, let cardObject = cardObject else { return }
            
            if isMyCard {
                
                HCFirebaseManager.shared.deleteId(
                    viewController: self,
                    userCollection: .myCards,
                    uid: user.uid,
                    id: cardObject.basicInfo.id,
                    loadingAnimation: startLoadingAnimation(viewController:)
                )
                
                isMyCard = !isMyCard
            } else {
                
                // add AddMyCardVC view
                
                self.view.endEditing(true)
                
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
                //                    strongSelf.tabBarController?.tabBar.isHidden = true
                
                self.addChild(addMyCardVC)
                
                addMyCardVC.loadViewIfNeeded()
                //                    addMyCardVC.view.translatesAutoresizingMaskIntoConstraints = false
                
                addMyCardVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                self.view.addSubview(addMyCardVC.view)
                
                //                    addMyCardVC.view.topAnchor.constraint(equalTo: strongSelf.view.topAnchor, constant: 0).isActive = true
                //
                //                    addMyCardVC.view.leadingAnchor.constraint(equalTo: strongSelf.view.leadingAnchor).isActive = true
                //
                //                    addMyCardVC.view.trailingAnchor.constraint(equalTo: strongSelf.view.trailingAnchor).isActive = true
                //
                //                    addMyCardVC.view.bottomAnchor.constraint(equalTo: strongSelf.view.bottomAnchor).isActive = true
                
                addMyCardVC.didMove(toParent: self)
                
                // 在 addMyCardVC 中按下確定新增
                addMyCardVC.addMyCardCompletionHandler = { [weak self]
                    (nickname,  needBillRemind, selectedDate)
                    in
                    
                    guard let strongSelf = self, let object = strongSelf.cardObject else { return }
                    
                    // 按下確定要新增再新增id
                    HCFirebaseManager.shared.addId(
                        userCollection: .myCards,
                        uid: user.uid,
                        id: cardObject.basicInfo.id,
                        addIdCompletionHandler: { [weak self] error in
                            
                            HCFirebaseManager.shared.setMyCard(
                                uid: user.uid,
                                id: object.basicInfo.id,
                                nickname: nickname,
                                needBillRemind: needBillRemind,
                                billDueDate: selectedDate
                            )
                    })
                    }
   
                isMyCard = !isMyCard
            }
            
            
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: NotificationNames.cardVCUpdateMyCard.rawValue),
                object: nil
            )
            
            isMyCardDidTouchHandler?()
            
        } else {
            
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                
                authVC.modalPresentationStyle = .overCurrentContext
                
                let navVC = UINavigationController(rootViewController: authVC)
                
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onToOfficialWeb(_ sender: Any) {
        
        openWebView(url: cardObject?.basicInfo.officialWeb ?? "")
    }
    
    @IBAction func onToApplyCard(_ sender: Any) {
        
        openWebView(url: cardObject?.basicInfo.getCardWeb ?? "")
    }
}

extension CardDetailViewController {
    
    private func setupTableView() {
        
        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: CardDetailTableViewHeaderView.self),
            bundle: nil
        )
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        
        topBackView.roundCorners(
            [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner],
            radius: 10)
    }
    
    private func setHeaderViewContent(cardName: String, bankName: String, image: String) {
        
        cardNameLabel.text = cardName
        
        bankNameLabel.text = bankName
        
        cardImageView.loadImage(image, placeHolder: UIImage.asset(.Image_Placeholder))
        
        toOfficialWebBtn.isRoundedView()
        
        toApplyCardBtn.isRoundedView()
    }
    
    private func setNavBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Share),
            style: .plain,
            target: self,
            action: #selector(onShare)
        )
    }
    
    func getcardDetail() {
        
        cardProvider.getCards(id: cardID, completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let cards):
                
                print(cards)
                
                strongSelf.cardObject = cards
                
//                guard let cardObject = strongSelf.cardObject else { return }
//
//                strongSelf.isCollected = cardObject.basicInfo.isCollected
                
                strongSelf.cardObject?.basicInfo.isCollected = strongSelf.isCollected
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    func cardAddObserver() {
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateCollectedCard),
                name: NSNotification.Name(NotificationNames.updateCollectedCard.rawValue),
                object: nil
        )
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateMyCard),
                name: NSNotification.Name(NotificationNames.cardVCUpdateMyCard.rawValue),
                object: nil
        )
    }
    
    @objc func updateCollectedCard() {
        
        /// 比對 id 有哪些 true，true 的話改物件狀態
        isCollected = false
        
        HCFirebaseManager.shared.collectedCardIds.forEach { (id) in
            
            if cardID == id {
                
                isCollected = true
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
        }
    }
    
    @objc func updateMyCard() {
        
        /// 比對 id 有哪些 true，true 的話改物件狀態
        isMyCard = false
        
        HCFirebaseManager.shared.myCardIds.forEach { (id) in
            
            if cardID == id {
                
                isMyCard = true
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
        }
    }
}

extension CardDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: CardDetailTableViewHeaderView.self)
        )

        guard let headerView = view as? CardDetailTableViewHeaderView,
            let cardObject = self.cardObject else {
                return view
        }

        headerView.layoutView(title: cardObject.detailInfo[section].sectionTitle)

        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        guard let headerView = view as? CardDetailTableViewHeaderView else { return }

        headerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: .gray)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension CardDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let cardObject = cardObject else { return 0 }
        
        return cardObject.detailInfo.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let cardObject = cardObject else { return 0 }
        
        return cardObject.detailInfo[section].content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CardDetailContentTableViewCell.self),
            for: indexPath
        )

        guard let contentCell = cell as? CardDetailContentTableViewCell, var cardObject = cardObject else {
            
            return cell
        }

        let data = cardObject.detailInfo[indexPath.section].content[indexPath.row]
        
        let content = data.isDetail ? data.detailContent : data.briefContent
        
        if data.detailContent == nil {

            isDetailAvailable = false
        } else {

            isDetailAvailable = true
        }
        
        contentCell.layoutCell(title: data.title, content: content, isDetail: data.isDetail, isDetailAvailable: isDetailAvailable)

        contentCell.showDetailDidTouchHandler = { [weak self] in

            guard let strongSelf = self,
                let indexPath = tableView.indexPath(for: cell) else { return }
            strongSelf.cardObject?.detailInfo[indexPath.section].content[indexPath.row].isDetail =
                !(strongSelf.cardObject?.detailInfo[indexPath.section].content[indexPath.row].isDetail)!
            
            contentCell.isDetail = !contentCell.isDetail
                
//            contentCell.layoutCell(title: data.title, content: data.detailContent, isDetail: data.isDetail)
            
//            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//            let contentOffset = self?.tableView.contentOffset
//            CATransaction.begin()
            strongSelf.tableView.reloadData()
//            CATransaction.setCompletionBlock({
//                self?.tableView.contentOffset = contentOffset!
//            })
//            CATransaction.commit()
        }

        return contentCell
    }
}

// tagCollectionView

extension CardDetailViewController {

    func setupCollectionView() {

        tagCollectionView.agRegisterCellWithNib(
            identifier: String(describing: CardTagCollectionViewCell.self),
            bundle: nil
        )
    }
}

extension CardDetailViewController: UICollectionViewDelegate {

}

extension CardDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardObject?.basicInfo.tags.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CardTagCollectionViewCell.self),
            for: indexPath
        )

        guard let tagCell = cell as? CardTagCollectionViewCell, let cardObject = cardObject else { return cell }

        tagCell.layoutCell(tag: cardObject.basicInfo.tags[indexPath.item])

        return tagCell
    }

}
