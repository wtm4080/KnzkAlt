//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

struct HTMLClassParser {
    let rawValue: String
    private var _processed = Set<String>()

    init(rawValue: String) {
        self.rawValue = rawValue

        // ignoring
        _processed.insert("fa")
    }

    lazy var keys: [String] = {
        rawValue.split(separator: " ")
                .map({String($0).lowercased()})
                .filter({!$0.isEmpty})
    }()

    var processedAttrs: Set<String> {
        return _processed
    }

    lazy var largeRate: CGFloat? = {
        guard let i = keys.index(where: {$0.hasPrefix("fa-") && $0.hasSuffix("x")}) else {
            return nil
        }

        let value = keys[i]

        guard value.count > 4 else {
            return nil
        }

        guard let rate = Double(value.dropFirst(3).dropLast(1)) else {
            return nil
        }

        guard rate > 0 else {
            return nil
        }

        _processed.insert(value)

        return CGFloat(min(rate, 10.0))
    }()

    lazy var isFlipVertical: Bool = {
        let key = "fa-flip-vertical"

        let isPresent = keys.contains(key)

        _processed.insert(key)

        return isPresent
    }()

    lazy var isFlipHorizontal: Bool = {
        let key = "fa-flip-horizontal"

        let isPresent = keys.contains(key)

        _processed.insert(key)

        return isPresent
    }()

    lazy var isSpin: Bool = {
        let key = "fa-spin"

        let isPresent = keys.contains(key)

        _processed.insert(key)

        return isPresent
    }()

    lazy var isPulse: Bool = {
        let key = "bbcode-pulse-loading"

        let isPresent = keys.contains(key)

        _processed.insert(key)

        return isPresent
    }()
}
