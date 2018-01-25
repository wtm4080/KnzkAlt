//
//  TimelineNavigation.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/12/23.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class TimelineNavigation: UINavigationController, ANShowStatusDetail, ANShowAccountDetail {
    override func viewDidLoad() {
        super.viewDidLoad()

        AppNotification.shared.observer.register(observer: self as ANShowStatusDetail)
        AppNotification.shared.observer.register(observer: self as ANShowAccountDetail)
    }

    func observeShowStatusDetail(statusDetail: StatusDetailParams) {
        let vc = StatusDetailVC(params: statusDetail)

        pushViewController(vc, animated: true)
    }

    func observeShowAccountDetail(accountDetail: AccountDetailParams) {
        let vc = AccountDetailVC(params: accountDetail)

        pushViewController(vc, animated: true)
    }
}
