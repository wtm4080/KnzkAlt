//
// Created by mopopo on 2017/11/13.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    static let shared = DataSource()

    private var _homeTL = DataSourceTimeline()
    private var _localTL = DataSourceTimeline()
    private var _federationTL = DataSourceTimeline()

    private var _currentTLKind = TLKind.home

    private override init() {
        super.init()

        Notifications.requestTL.register(
                observer: self,
                selector: #selector(type(of: self)._observeRequestTL(n:))
        )
        Notifications.switchTL.register(
                observer: self,
                selector: #selector(type(of: self)._observeSwitchTL(n:))
        )
        Notifications.logoutPerformed.register(
                observer: self,
                selector: #selector(type(of: self)._observeLogoutPerformed(n:))
        )
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    @objc private func _observeRequestTL(n: Notification) {
        _currentTL.loadStatuses(tlParams: Notifications.tlParams(from: n)!)
    }

    @objc private func _observeSwitchTL(n: Notification) {
        let tlParams = Notifications.tlParams(from: n)!

        _currentTLKind = tlParams.kind

        Notifications.switchedTL.post(tlParams: tlParams)
    }

    @objc private func _observeLogoutPerformed(n: Notification) {
        _homeTL = DataSourceTimeline()
        _localTL = DataSourceTimeline()
        _federationTL = DataSourceTimeline()

        Notifications.switchTL.post(
                tlParams: TLParams(kind: .home, pos: .unspecified)
        )
    }

    func tableView(_ _: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _currentTL.statuses[indexPath.row].view
    }

    func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return _currentTL.statuses.count
    }

    func cellHeight(at: Int) -> CGFloat {
        let cell = _currentTL.statuses[at].view

        return cell.cellHeight
    }

    private var _currentTL: DataSourceTimeline {
        switch _currentTLKind {
            case .home:
                return _homeTL
            case .local:
                return _localTL
            case .federation:
                return _federationTL
        }
    }
}
