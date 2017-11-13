//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class HomeVC: UITableViewController {
    private let _refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = DataSource.shared

        _refreshControl.addTarget(
                self,
                action: #selector(type(of: self)._refresh(sender:)),
                for: .valueChanged)
        tableView.refreshControl = _refreshControl

        Notifications.loadedHomeTL.register(
                observer: self,
                selector: #selector(type(of: self)._observeLoadedHomeTL(n:)))

        Notifications.requestHomeTL.post()
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    @objc private func _observeLoadedHomeTL(n: Notification) {
        tableView.reloadData()
    }

    @objc private func _refresh(sender: UIRefreshControl) {
        _refreshControl.endRefreshing()
    }

    private func _refreshBottom() {
        NSLog("Should refresh!")
    }

    override func scrollViewDidScroll(_ sv: UIScrollView) {
//        NSLog("Bounds: \(sv.bounds)")
//        NSLog("Content offset: \(sv.contentOffset), size: \(sv.contentSize), inset: \(sv.contentInset)")

        let tabBarHeight = CGFloat(50)
        let fixedBoundsHeight = sv.bounds.size.height - tabBarHeight
        let contentSize = sv.contentSize.height - fixedBoundsHeight
        let bottomDistance = abs(contentSize - sv.contentOffset.y)
        //NSLog("Bottom distance: \(bottomDistance)")

        let bottomRefreshThreshold = CGFloat(50)
        if (bottomDistance < bottomRefreshThreshold) {
            _refreshBottom()
        }
    }
}
