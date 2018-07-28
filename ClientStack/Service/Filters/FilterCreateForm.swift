//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct FilterCreateForm {
    /// String that contains keyword or phrase
    let phrase: String

    /// Array of strings that means filtering context.
    /// Each string is one of `home`, `notifications`, `public`, `thread`.
    let context: [FilterContext]

    /// Boolean that indicates irreversible filtering on server side
    let isIrreversible: Bool?
    
    /// Boolean that indicates word match
    let isWholeWord: Bool?

    /// Number that indicates seconds.
    /// Filter will be expire in seconds after API processed.
    /// `null` or blank string means "don't change".
    /// Default is unlimited.
    let expiresIn: UInt?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [
            "phrase": phrase,
            "context": context.map({ $0.rawValue })
        ]

        if let iR = isIrreversible {
            params["irreversible"] = iR
        }

        if let iWW = isWholeWord {
            params["whole_word"] = iWW
        }

        if let eI = expiresIn {
            params["expires_in"] = eI
        }

        return params
    }
}
