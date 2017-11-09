//
// Created by mopopo on 2017/11/09.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation

enum Notifications: String {
    case AccessTokenRefreshed = "access_token_refreshed"
    case LogoutPerformed = "logout_performed"

    private var _nc: NotificationCenter {
        return NotificationCenter.default
    }

    private var _name: Notification.Name {
        return Notification.Name(self.rawValue)
    }

    func post(userInfo: [AnyHashable: Any]? = nil) {
        _nc.post(name: _name, object: nil, userInfo: userInfo)
    }

    func register(observer: Any, selector: Selector) {
        _nc.addObserver(observer, selector: selector, name: _name, object: nil)
    }

    func unregister(observer: Any) {
        _nc.removeObserver(observer, name: _name, object: nil)
    }

    static func unregisterAll(observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
