//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeCustomValue: CustomDebugStringConvertible {
    let multiFactor: UInt

    init(multiFactor: UInt = 1) {
        self.multiFactor = multiFactor
    }

    func merging(other: BBCodeCustomValue) -> BBCodeCustomValue {
        return BBCodeCustomValue(multiFactor: multiFactor + other.multiFactor)
    }

    var debugDescription: String {
        return "BBCodeCustomValue(multiFactor: \(multiFactor))"
    }

    var position: CGPoint?
}
