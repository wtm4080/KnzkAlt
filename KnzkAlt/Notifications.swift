//
// Created by mopopo on 2017/11/09.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation

enum Notifications {
    case accessTokenRefreshed
    case logoutPerformed

    case requestHomeTL
    case requestHomeTLTop
    case requestHomeTLBottom
    case loadedHomeTL

    private var _nc: NotificationCenter {
        return NotificationCenter.default
    }

    private var _name: Notification.Name {
        return Notification.Name(String(describing: self))
    }

    func post(userInfo: [AnyHashable: Any]? = nil) {
        if Thread.isMainThread {
            _nc.post(name: _name, object: nil, userInfo: userInfo)
        }
        else {
            let nc = _nc
            let name = _name

            DispatchQueue.main.async {
                nc.post(name: name, object: nil, userInfo: userInfo)
            }
        }
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
