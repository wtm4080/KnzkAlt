//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit
import Hydra

class HomeVC: UITableViewController, UITableViewDataSourcePrefetching {
    private var _loadingStatuses: Promise<Result<[Status]>>?
    private var _statuses: [Status] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.prefetchDataSource = self
    }

    override func tableView(_ _: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = _statuses[indexPath.row]

        return HomeVC._statusToCell(s: status)
    }

    override func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return _statuses.count
    }

    func tableView(_ _: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    }

    func tableView(_ _: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }

    private static func _statusToCell(s: Status) -> StatusCell {
        let cellOwner = StatusCellOwner()

        return cellOwner.cell
    }
}
