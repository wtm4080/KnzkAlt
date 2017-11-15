//
// Created by mopopo on 2017/11/14.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class TimelineSwitch: UIView {
    // Overriding intrinsicContentSize is needed to send touch event to sub-buttons on iOS 11
    // https://qiita.com/KikurageChan/items/f42f8e687888ee944c35
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 324, height: 30)
    }
}

class TimelineSwitchOwner: NibViewOwner<TimelineSwitch> {
    private var _currentTLKind = TLKind.home

    var currentTLKind: TLKind {
        return _currentTLKind
    }

    @IBAction func homeAction(_ sender: Any) {
        _currentTLKind = .home

        Notifications.switchTL.post(
                tlParams: TLParams(kind: .home, pos: .unspecified)
        )
    }
    
    @IBAction func localAction(_ sender: Any) {
        _currentTLKind = .local

        Notifications.switchTL.post(
                tlParams: TLParams(kind: .local, pos: .unspecified)
        )
    }
    
    @IBAction func federationAction(_ sender: Any) {
        _currentTLKind = .federation

        Notifications.switchTL.post(
                tlParams: TLParams(kind: .federation, pos: .unspecified)
        )
    }
}
