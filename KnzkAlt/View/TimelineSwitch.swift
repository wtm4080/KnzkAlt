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
    
    @IBOutlet weak private var homeButton: UIButton!
    @IBOutlet weak private var localButton: UIButton!
    @IBOutlet weak private var federationButton: UIButton!

    override init() {
        super.init()

        _updateButtonStates()
    }
    
    var currentTLKind: TLKind {
        return _currentTLKind
    }

    @IBAction func homeAction(_ sender: Any) {
        _buttonAction(tlKind: .home)
    }
    
    @IBAction func localAction(_ sender: Any) {
        _buttonAction(tlKind: .local)
    }
    
    @IBAction func federationAction(_ sender: Any) {
        _buttonAction(tlKind: .federation)
    }

    private func _buttonAction(tlKind: TLKind) {
        _currentTLKind = tlKind

        _updateButtonStates()

        Notifications.switchTL.post(
                tlParams: TLParams(kind: tlKind, pos: .unspecified)
        )
    }

    private func _updateButtonStates() {
        switch _currentTLKind {
            case .home:
                homeButton.isSelected = true
                localButton.isSelected = false
                federationButton.isSelected = false
            case .local:
                homeButton.isSelected = false
                localButton.isSelected = true
                federationButton.isSelected = false
            case .federation:
                homeButton.isSelected = false
                localButton.isSelected = false
                federationButton.isSelected = true
        }
    }
}
