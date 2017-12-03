//
// Created by mopopo on 2017/12/03.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

struct HTMLStyleParser {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    lazy var keyValues: [String: [String]] = {
        let kvs = rawValue.split(separator: ";")

        let kvPairs: [(String, [String])] = kvs.map {

            let pair = $0.split(separator: ":")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            let values = (pair.dropFirst().first ?? "")
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "'\"")) }

            return (
                    String(pair.first ?? ""),
                    values
            )
        }.filter { !$0.0.isEmpty }

        return [String: [String]](uniqueKeysWithValues: kvPairs)
    }()

    let foregroundColorKey = "color"
    lazy var foregroundColor: UIColor? = {
        guard let value = keyValues[foregroundColorKey]?.first else {
            return nil
        }

        if value.hasPrefix("#") {
            return CSSColorParser.fromHex(hex: value)
        }
        else {
            return CSSColorParser.fromKeyword(key: value)
        }
    }()

    // https://developer.mozilla.org/ja/docs/Web/CSS/font-style
    let isItalicKey = "font-style"
    lazy var isItalic: Bool = {
        guard let value = keyValues[isItalicKey]?.first else {
            return false
        }

        switch value.lowercased() {

        case "normal":
            return false

        case "italic", "oblique":
            return true

        default:
            return false
        }
    }()
}
