//
// Created by mopopo on 2018/01/25.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

protocol AppNotificationObserving: class {}

protocol ANAccessTokenRefreshed: AppNotificationObserving {
    func observeAccessTokenRefreshed()
}

protocol ANLogoutPerformed: AppNotificationObserving {
    func observeLogoutPerformed()
}

protocol ANRequestTL: AppNotificationObserving {
    func observeRequestTL(tlParams: TLParams)
}

protocol ANLoadedTL: AppNotificationObserving {
    func observeLoadedTL(tlParams: TLParams)
}

protocol ANSwitchTL: AppNotificationObserving {
    func observeSwitchTL(tlParams: TLParams)
}

protocol ANSwitchedTL: AppNotificationObserving {
    func observeSwitchedTL(tlParams: TLParams)
}

protocol ANShowStatusDetail: AppNotificationObserving {
    func observeShowStatusDetail(statusDetail: StatusDetailParams)
}

protocol ANShowAccountDetail: AppNotificationObserving {
    func observeShowAccountDetail(accountDetail: AccountDetailParams)
}

protocol ANLoadedAttachment: AppNotificationObserving {
    func observeLoadedAttachment()
}
