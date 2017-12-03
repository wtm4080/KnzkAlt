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

    // https://developer.mozilla.org/ja/docs/Web/CSS/font-weight
    // https://developer.apple.com/documentation/uikit/uifontdescriptor.traitkey/1616668-weight
    let fontWeightKey = "font-weight"
    lazy var fontWeight: UIFont.Weight? = {
        guard let value = keyValues[fontWeightKey]?.first else {
            return nil
        }

        switch value.lowercased() {

        case "normal":
            return UIFont.Weight.regular
        case "bold":
            return UIFont.Weight.bold
        case "lighter":
            return UIFont.Weight.light
        case "bolder":
            return UIFont.Weight.medium

        default:
            if let n = Int(value) {
                // [100, 900] to [-1.0, 1.0]
                let normalized = CGFloat(n - 500) / CGFloat(400)

                return UIFont.Weight(normalized)
            }
            else {
                return nil
            }
        }
    }()

    let fontSizeKey = "font-size"
    lazy var fontSize: CGFloat? = {
        guard let value = keyValues[fontSizeKey]?.first else {
            return nil
        }

        let medium = BBCodeView.defaultFontSize

        switch value.lowercased() {

        case "xx-small":
            return medium * 0.4
        case "x-small":
            return medium * 0.6
        case "small":
            return medium * 0.8
        case "medium":
            return medium
        case "large":
            return medium * 1.2
        case "x-large":
            return medium * 1.4
        case "xx-large":
            return medium * 1.6

        case "larger":
            return medium * 1.2
        case "smaller":
            return medium * 0.8

        default:
            if value.count > 2 {
                if value.hasSuffix("px") {
                    return Float(value.dropLast(2)).map { CGFloat($0) }
                }
                else if value.hasSuffix("em") {
                    return Float(value.dropLast(2)).map { medium * CGFloat($0) }
                }
                else {
                    return nil
                }
            }
            else if value.count > 1 && value.hasSuffix("%") {
                if let normalized = Int(value).map({ Double($0) / 100.0 }) {
                    return medium * CGFloat(normalized)
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
    }()
}
