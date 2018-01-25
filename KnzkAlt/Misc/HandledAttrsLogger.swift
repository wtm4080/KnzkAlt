//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation

struct HandledAttrsLogger {
    private var _handledAttrs = Set<String>()

    mutating func markAsHandled(attr: String) {
        _handledAttrs.insert(attr)
    }

    mutating func markAsHandled(attrs: Set<String>) {
        _handledAttrs.formUnion(attrs)
    }

    func logUnhandledAttrs(allAttrs: [String: Any], tagName: String) {
        let unhandled = allAttrs.filter { !_handledAttrs.contains($0.key) }

        unhandled.forEach {
            NSLog("[Warning] Unhandled HTML attr for <\(tagName)> tag: \(String(describing: $0))")
        }
    }

    func logUnhandledAttrs(allAttrs: [String], tagName: String) {
        let unhandled = allAttrs.filter { !_handledAttrs.contains($0) }

        unhandled.forEach {
            NSLog("[Warning] Unhandled HTML attr for <\(tagName)> tag: \(String(describing: $0))")
        }
    }
}
