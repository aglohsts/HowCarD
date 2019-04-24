//
//  CardDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {
    
    var cardID: String = ""
    
    let cardProvider = CardProvider()
    
    var collectedCardIds = [String]()
    
    @IBOutlet weak var collectedBtn: UIButton!
    
    var isCollected: Bool = false{
    
        didSet {

            if isCollected {
                
                DispatchQueue.main.async {
                    
//                    self.collectedBtn.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
                    
                    self.collectedBtn.setTitle("V", for: .normal)
                }
            } else {

                DispatchQueue.main.async {
                    
//                    self.collectedBtn.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
                    
                    self.collectedBtn.setTitle("X", for: .normal)
                }
            }
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
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
                self.tagCollectionView.reloadData()
                
                self.setHeaderViewContent(cardName: self.cardObject?.basicInfo.name ?? "", bankName: self.cardObject?.basicInfo.bank ?? "")
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

    var touchHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        setupCollectionView()

        setNavBar()
        
        getcardDetail()
    
    }

    private func setupTableView() {

        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: CardDetailTableViewHeaderView.self),
            bundle: nil
        )

        tableView.separatorStyle = .none
    }
    
    private func setHeaderViewContent(cardName: String, bankName: String) {
        
        cardNameLabel.text = cardName
        
        bankNameLabel.text = bankName
    }

    private func setNavBar() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icons_24px_Share),
            style: .plain,
            target: self,
            action: #selector(onShare))

    }

    @objc private func onShare() {

    }
    
    @IBAction func onCollectCard(_ sender: Any) {
        
        isCollected = !isCollected
        
    }
}

extension CardDetailViewController {
    
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
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
}

extension CardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: CardDetailTableViewHeaderView.self)
        )

        guard let headerView = view as? CardDetailTableViewHeaderView, let cardObject = self.cardObject else { return view }

        headerView.layoutView(title: cardObject.detailInfo[section].sectionTitle)

        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        guard let headerView = view as? CardDetailTableViewHeaderView else { return }

        headerView.contentView.backgroundColor = UIColor.lightGray
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

        var data = cardObject.detailInfo[indexPath.section].content[indexPath.row]
        
        let content = data.isDetail ? data.detailContent : data.briefContent
        
        contentCell.layoutCell(title: data.title, content: content, isDetail: data.isDetail)

        contentCell.touchHandler = { [weak self] in

            guard let indexPath = tableView.indexPath(for: cell) else { return }
            self?.cardObject?.detailInfo[indexPath.section].content[indexPath.row].isDetail = !(self?.cardObject?.detailInfo[indexPath.section].content[indexPath.row].isDetail)!
            
            contentCell.isDetail = !contentCell.isDetail
                
//            contentCell.layoutCell(title: data.title, content: data.detailContent, isDetail: data.isDetail)
            
//            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//            let contentOffset = self?.tableView.contentOffset
//            CATransaction.begin()
            self?.tableView.reloadData()
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
