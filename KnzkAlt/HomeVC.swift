//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class HomeVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = DataSource.shared

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
}
