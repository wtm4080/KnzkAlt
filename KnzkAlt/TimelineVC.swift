//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class TimelineVC: UITableViewController {
    private let _refreshControl = UIRefreshControl()

    private var _reservedRefreshingBottom = false

    private let _timelineSwitchOwner = TimelineSwitchOwner()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = DataSource.shared

        _refreshControl.addTarget(
                self,
                action: #selector(type(of: self)._refresh(sender:)),
                for: .valueChanged)
        tableView.refreshControl = _refreshControl

        navigationItem.titleView = _timelineSwitchOwner.view

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

        _refreshControl.endRefreshing()

        tableView.flashScrollIndicators()

        _reservedRefreshingBottom = false
    }

    @objc private func _refresh(sender: UIRefreshControl) {
        Notifications.requestHomeTLTop.post()
    }

    private func _refreshBottom() {
        Notifications.requestHomeTLBottom.post()
    }

    override func scrollViewDidScroll(_ sv: UIScrollView) {
        if !_reservedRefreshingBottom {
            let tabBarHeight = CGFloat(50)
            let fixedBoundsHeight = sv.bounds.size.height - tabBarHeight
            let contentSize = sv.contentSize.height - fixedBoundsHeight
            let bottomDistance = abs(contentSize - sv.contentOffset.y)

            let bottomRefreshThreshold = CGFloat(50)

            _reservedRefreshingBottom = bottomDistance < bottomRefreshThreshold
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if _reservedRefreshingBottom {
            _refreshBottom()
        }
    }
}
