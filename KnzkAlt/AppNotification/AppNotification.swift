//
// Created by mopopo on 2018/01/25.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

fileprivate func _doOnMain(action: @escaping () -> ()) {
    DispatchQueue.main.async {
        action()
    }
}

struct AppNotification {
    static let shared = AppNotification()

    private init () {
        let observer = Observer()
        self.observer = observer

        self.post = Posting(observer: observer)
    }

    let observer: Observer
    let post: Posting

    struct Posting {
        private let _observer: Observer

        fileprivate init(observer: Observer) {
            _observer = observer
        }

        private static func _performPost(
                observers: @escaping () -> [_ObserverWrapper],
                perform: @escaping (AnyObject?) -> Bool,
                handleAliveObservers: @escaping ([_ObserverWrapper]) -> ()
        ) {
            _doOnMain {
                let os = observers()

                guard !os.isEmpty else {
                    return
                }

                var aliveObservers = [_ObserverWrapper]()

                for ow in os {
                    if perform(ow.observer) {
                        aliveObservers.append(ow)
                    }
                }

                handleAliveObservers(aliveObservers)
            }
        }

        func accessTokenRefreshed() {
            Posting._performPost(
                    observers: { self._observer._accessTokenRefreshed },
                    perform: {
                        if let o = $0 as? ANAccessTokenRefreshed {
                            o.observeAccessTokenRefreshed()
                            
                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._accessTokenRefreshed = $0
                    }
            )
        }

        func logoutPerformed() {
            Posting._performPost(
                    observers: { self._observer._logoutPerformed },
                    perform: {
                        if let o = $0 as? ANLogoutPerformed {
                            o.observeLogoutPerformed()

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._logoutPerformed = $0
                    }
            )
        }

        func requestTL(tlParams: TLParams) {
            Posting._performPost(
                    observers: { self._observer._requestTL },
                    perform: {
                        if let o = $0 as? ANRequestTL {
                            o.observeRequestTL(tlParams: tlParams)

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._requestTL = $0
                    }
            )
        }

        func loadedTL(tlParams: TLParams) {
            Posting._performPost(
                    observers: { self._observer._loadedTL },
                    perform: {
                        if let o = $0 as? ANLoadedTL {
                            o.observeLoadedTL(tlParams: tlParams)

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._loadedTL = $0
                    }
            )
        }

        func switchTL(tlParams: TLParams) {
            Posting._performPost(
                    observers: { self._observer._switchTL },
                    perform: {
                        if let o = $0 as? ANSwitchTL {
                            o.observeSwitchTL(tlParams: tlParams)

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._switchTL = $0
                    }
            )
        }

        func switchedTL(tlParams: TLParams) {
            Posting._performPost(
                    observers: { self._observer._switchedTL },
                    perform: {
                        if let o = $0 as? ANSwitchedTL {
                            o.observeSwitchedTL(tlParams: tlParams)

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._switchedTL = $0
                    }
            )
        }

        func showStatusDetail(statusDetail: StatusDetailParams) {
            Posting._performPost(
                    observers: { self._observer._showStatusDetail },
                    perform: {
                        if let o = $0 as? ANShowStatusDetail {
                            o.observeShowStatusDetail(statusDetail: statusDetail)

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._showStatusDetail = $0
                    }
            )
        }

        func showAccountDetail(accountDetail: AccountDetailParams) {
            Posting._performPost(
                    observers: { self._observer._showAccountDetail },
                    perform: {
                        if let o = $0 as? ANShowAccountDetail {
                            o.observeShowAccountDetail(accountDetail: accountDetail)

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._showAccountDetail = $0
                    }
            )
        }

        func loadedAttachment() {
            Posting._performPost(
                    observers: { self._observer._loadedAttachment },
                    perform: {
                        if let o = $0 as? ANLoadedAttachment {
                            o.observeLoadedAttachment()

                            return true
                        }
                        else {
                            return false
                        }
                    },
                    handleAliveObservers: {
                        self._observer._loadedAttachment = $0
                    }
            )
        }
    }

    fileprivate struct _ObserverWrapper {
        weak var observer: AppNotificationObserving?
    }

    class Observer {
        fileprivate var _accessTokenRefreshed = [_ObserverWrapper]()
        fileprivate var _logoutPerformed = [_ObserverWrapper]()
        fileprivate var _requestTL = [_ObserverWrapper]()
        fileprivate var _loadedTL = [_ObserverWrapper]()
        fileprivate var _switchTL = [_ObserverWrapper]()
        fileprivate var _switchedTL = [_ObserverWrapper]()
        fileprivate var _showStatusDetail = [_ObserverWrapper]()
        fileprivate var _showAccountDetail = [_ObserverWrapper]()
        fileprivate var _loadedAttachment = [_ObserverWrapper]()

        fileprivate init() {}

        func register(observer: ANAccessTokenRefreshed) {
            _doOnMain {
                self._accessTokenRefreshed.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANLogoutPerformed) {
            _doOnMain {
                self._logoutPerformed.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANRequestTL) {
            _doOnMain {
                self._requestTL.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANLoadedTL) {
            _doOnMain {
                self._loadedTL.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANSwitchTL) {
            _doOnMain {
                self._switchTL.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANSwitchedTL) {
            _doOnMain {
                self._switchedTL.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANShowStatusDetail) {
            _doOnMain {
                self._showStatusDetail.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANShowAccountDetail) {
            _doOnMain {
                self._showAccountDetail.append(_ObserverWrapper(observer: observer))
            }
        }

        func register(observer: ANLoadedAttachment) {
            _doOnMain {
                self._loadedAttachment.append(_ObserverWrapper(observer: observer))
            }
        }
    }
}
