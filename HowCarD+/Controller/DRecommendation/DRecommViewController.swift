//
//  DRecommViewController.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import FoldingCell

class DRecommViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Const {
        static let closeCellHeight: CGFloat = 135
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension DRecommViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //        cell.number = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as? FoldingCell else {
            
            return UITableViewCell()
        }
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FoldingCell else {
            
            return
        }
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
}

//
//
//
//{
//
//    let categoryArray = ["最新卡片", "精選卡片", "最新優惠", "精選優惠"]
//
//    @IBOutlet weak var tableView: UITableView! {
//        didSet {
//
//            tableView.delegate = self
//
//            tableView.dataSource = self
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTableView()
//    }
//
//    private func setupTableView() {
//        tableView.showsVerticalScrollIndicator = false
//
//        tableView.separatorStyle = .none
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension DRecommViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 153
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//}
//
//extension DRecommViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return categoryArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: String(describing: DRecommTableViewHeaderCell.self),
//            for: indexPath
//        )
//
//        guard let dRecommCell = cell as? DRecommTableViewHeaderCell else { return cell }
//
//        dRecommCell.layoutCell(image: UIImage.asset(.Image_Placeholder)!, title: categoryArray[indexPath.row])
//
//        return dRecommCell
//    }
//
//}
