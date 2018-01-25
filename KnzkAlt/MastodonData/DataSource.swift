//
// Created by mopopo on 2017/11/13.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource, ANRequestTL, ANSwitchTL, ANLogoutPerformed, ANAccessTokenRefreshed {
    static let shared = DataSource()

    private var _homeTL = DataSourceTimeline()
    private var _localTL = DataSourceTimeline()
    private var _federationTL = DataSourceTimeline()

    private var _currentTLKind = TLKind.home

    private override init() {
        super.init()

        AppNotification.shared.observer.register(observer: self as ANRequestTL)
        AppNotification.shared.observer.register(observer: self as ANSwitchTL)
        AppNotification.shared.observer.register(observer: self as ANLogoutPerformed)
        AppNotification.shared.observer.register(observer: self as ANAccessTokenRefreshed)
    }

    func observeRequestTL(tlParams: TLParams) {
        _currentTL.loadStatuses(tlParams: tlParams)
    }

    func observeSwitchTL(tlParams: TLParams) {
        _currentTLKind = tlParams.kind

        AppNotification.shared.post.switchedTL(tlParams: tlParams)
    }

    func observeLogoutPerformed() {
        _reset()
    }

    func observeAccessTokenRefreshed() {
        _reset()
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

    private func _reset() {
        _homeTL = DataSourceTimeline()
        _localTL = DataSourceTimeline()
        _federationTL = DataSourceTimeline()

        AppNotification.shared.post.switchTL(
                tlParams: TLParams(kind: .home, pos: .unspecified)
        )
    }
}
