//
// Created by mopopo on 2017/11/09.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation

enum TLKind {
    case home
    case local
    case federation
}

enum LoadPosition {
    case top
    case bottom
    case unspecified
}

struct TLParams {
    let kind: TLKind
    let pos: LoadPosition
}

enum Notifications {
    case accessTokenRefreshed
    case logoutPerformed

    case requestTL
    case loadedTL

    case switchTL
    case switchedTL

    case showStatusDetail

    private var _nc: NotificationCenter {
        return NotificationCenter.default
    }

    private var _name: Notification.Name {
        return Notification.Name(String(describing: self))
    }

    func post() {
        switch self {
            case .accessTokenRefreshed, .logoutPerformed:
                _post()
            default:
                fatalError("Invalid posting case without params.")
        }
    }

    func post(tlParams: TLParams) {
        switch self {
            case .requestTL, .loadedTL, .switchTL, .switchedTL:
                _post(userInfo: [String(describing: TLParams.self): tlParams])
            default:
                fatalError("Invalid posting case with TLParams: \(String(describing: self))")
        }
    }

    func post(statusDetail: StatusDetailParams) {
        switch self {
        case .showStatusDetail:
            _post(userInfo: [String(describing: StatusDetailParams.self): statusDetail])
        default:
            fatalError("Invalid posting case with StatusDetailParams: \(String(describing: self))")
        }
    }

    private func _post(userInfo: [AnyHashable: Any]? = nil) {
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

    static func tlParams(from n: Notification) -> TLParams? {
        guard let userInfo = n.userInfo else {
            return nil
        }

        guard let params = userInfo[String(describing: TLParams.self)] else {
            return nil
        }

        return params as? TLParams
    }

    static func statusDetailParams(from n: Notification) -> StatusDetailParams? {
        guard let userInfo = n.userInfo else {
            return nil
        }

        guard let params = userInfo[String(describing: StatusDetailParams.self)] else {
            return nil
        }

        return params as? StatusDetailParams
    }
}
