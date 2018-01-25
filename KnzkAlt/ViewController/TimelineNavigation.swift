//
//  TimelineNavigation.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/12/23.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class TimelineNavigation: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        Notifications.showStatusDetail.register(
                observer: self,
                selector: #selector(type(of: self)._observeShowStatusDetail(n:))
        )
        Notifications.showAccountDetail.register(
                observer: self,
                selector: #selector(type(of: self)._observeShowAccountDetail(n:))
        )
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    @objc private func _observeShowStatusDetail(n: Notification) {
        let params = Notifications.statusDetailParams(from: n)!

        let vc = StatusDetailVC(params: params)

        pushViewController(vc, animated: true)
    }

    @objc private func _observeShowAccountDetail(n: Notification) {
        let params = Notifications.accountDetailParams(from: n)!

        let vc = AccountDetailVC(params: params)

        pushViewController(vc, animated: true)
    }
}
