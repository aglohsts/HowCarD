//
//  CardDetailViewController.swift
//  HowCarD+
//
//  Created by lohsts on 2019/4/8.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

struct CardIntro {

    let title: String

    let content: String

    let contentDetail: String

    var isDetail: Bool
}

class CardDetailViewController: UIViewController {

    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    var tagArray = ["回饋", "網路購物"]

    lazy var datas: [CardIntro] = [

        CardIntro(title: "123",
                  content: "12345",
                  contentDetail: "123456789123456789123456789123456789123456789123456789123456789",
                  isDetail: false),

        CardIntro(title: "123",
                  content: "12345",
                  contentDetail: "123456789123456789123456789123456789123456789123456789123456789",
                  isDetail: false),

        CardIntro(title: "123",
                  content: "12345",
                  contentDetail: "123456789123456789123456789123456789123456789123456789123456789",
                  isDetail: false)

    ]

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
        
        setHeaderViewContent(cardName: "@Gogo卡", bankName: "台新銀行")
    }

    private func setupTableView() {

        tableView.agRegisterHeaderWithNib(
            identifier: String(describing: CardDetailTableViewHeaderView.self),
            bundle: nil
        )

        tableView.separatorStyle = .none

    }
    
    private func setHeaderViewContent(cardName: String, bankName: String){
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
}

extension CardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: CardDetailTableViewHeaderView.self)
        )

        guard let headerView = view as? CardDetailTableViewHeaderView else { return view }

        headerView.layoutView(title: "123")

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
        return datas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CardDetailContentTableViewCell.self),
            for: indexPath
        )

        guard let contentCell = cell as? CardDetailContentTableViewCell else { return cell }

        let data = datas[indexPath.row]

        let content = data.isDetail ? data.contentDetail : data.content

        contentCell.layoutCell(
            title: data.title,
            detailContent: content,
            isDetail: data.isDetail)

        contentCell.touchHandler = { [weak self] in

            guard let indexPath = tableView.indexPath(for: cell) else { return }

            self?.datas[indexPath.row].isDetail = !self!.datas[indexPath.row].isDetail

            self?.tableView.reloadRows(at: [indexPath], with: .automatic)

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
        return tagArray.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CardTagCollectionViewCell.self),
            for: indexPath
        )

        guard let tagCell = cell as? CardTagCollectionViewCell else { return cell }

        tagCell.layoutCell(tag: tagArray[indexPath.item])

        return tagCell
    }

}
