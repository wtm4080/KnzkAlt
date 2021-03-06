//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class TimelineVC: UITableViewController, ANLoadedTL, ANSwitchedTL, ANLoadedAttachment {
    private let _refreshControl = UIRefreshControl()

    private var _reservedRefreshingBottom = false

    private let _timelineSwitchOwner = TimelineSwitchOwner()

    private var _tlTopIndexPaths: [TLKind: IndexPath] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = DataSource.shared

        _refreshControl.addTarget(
                self,
                action: #selector(type(of: self)._refresh(sender:)),
                for: .valueChanged)
        tableView.refreshControl = _refreshControl

        navigationItem.titleView = _timelineSwitchOwner.view

        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension

        AppNotification.shared.observer.register(observer: self as ANLoadedTL)
        AppNotification.shared.observer.register(observer: self as ANSwitchedTL)
        AppNotification.shared.observer.register(observer: self as ANLoadedAttachment)

        _postRequestTL(pos: .unspecified)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _resumeBBCodeAnimations()
    }

    func observeLoadedTL(tlParams: TLParams) {
        tableView.reloadData()

        _refreshControl.endRefreshing()

        tableView.flashScrollIndicators()

        _reservedRefreshingBottom = false
    }

    func observeSwitchedTL(tlParams: TLParams) {
        tableView.reloadData()

        if tableView.numberOfRows(inSection: 0) == 0 {
            _postRequestTL(pos: .unspecified)
        }
        else if let topIndexPath = _tlTopIndexPaths[_timelineSwitchOwner.currentTLKind] {
            tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)

            tableView.flashScrollIndicators()
        }
    }

    func observeLoadedAttachment() {
        tableView.reloadData()
    }

    @objc private func _refresh(sender: UIRefreshControl) {
        _postRequestTL(pos: .top)
    }

    private func _refreshBottom() {
        _postRequestTL(pos: .bottom)
    }

    private func _postRequestTL(pos: LoadPosition) {
        AppNotification.shared.post.requestTL(
                tlParams: TLParams(kind: _timelineSwitchOwner.currentTLKind, pos: pos)
        )
    }

    override func tableView(
            _ tableView: UITableView,
            estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return DataSource.shared.cellHeight(at: indexPath.row)
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

    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        _tlTopIndexPaths[_timelineSwitchOwner.currentTLKind] = tableView.indexPathsForVisibleRows?.first
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if _reservedRefreshingBottom {
            _refreshBottom()
        }

        _tlTopIndexPaths[_timelineSwitchOwner.currentTLKind] = tableView.indexPathsForVisibleRows?.first

        _resumeBBCodeAnimations()
    }

    private func _resumeBBCodeAnimations() {
        tableView.visibleCells.forEach {
            guard let cell = $0 as? StatusCell else {
                return
            }

            cell.resumeBBCodeAnimations()
        }
    }
}
