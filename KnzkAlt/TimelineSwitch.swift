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
    @IBAction func homeAction(_ sender: Any) {
        NSLog("Home timeline!")
    }
    
    @IBAction func localAction(_ sender: Any) {
        NSLog("Local timeline!")
    }
    
    @IBAction func federationAction(_ sender: Any) {
        NSLog("Federation timeline!")
    }
}
