//
// Created by mopopo on 2017/11/13.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    static let shared = DataSource()

    private let _homeTL = DataSourceTimeline()

    private override init() {
        super.init()

        Notifications.requestTL.register(
                observer: self,
                selector: #selector(type(of: self)._observeRequestTL(n:)))
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    @objc private func _observeRequestTL(n: Notification) {
        _homeTL.loadStatuses(tlParams: Notifications.tlParams(from: n)!)
    }

    func tableView(_ _: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _homeTL.statuses[indexPath.row].view
    }

    func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return _homeTL.statuses.count
    }
}
