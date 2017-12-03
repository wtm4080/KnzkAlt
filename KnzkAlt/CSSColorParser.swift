//
// Created by mopopo on 2017/12/03.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

// https://qiita.com/Kyomesuke3/items/eae6216b13c651254f64
extension UIColor {
    convenience init?(hex: String) {
        let normalized: String = {
            let numSignStripped = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
            let uppercased = numSignStripped.uppercased()

            let hex = uppercased
            switch hex.count {
            case 3: // RGB
                return "\(hex[0])\(hex[0])\(hex[1])\(hex[1])\(hex[2])\(hex[2])FF"
            case 4: // RGBA
                return "\(hex[0])\(hex[0])\(hex[1])\(hex[1])\(hex[2])\(hex[2])\(hex[3])\(hex[3])"
            case 6: // RRGGBB
                return hex + "FF"
            case 8: // RRGGBBAA
                return hex
            default:
                return ""
            }
        }()

        if let rawValue = UInt32(normalized, radix: 16) {
            self.init(hex32: rawValue)
        }
        else {
            return nil
        }
    }

    convenience init(hex32: UInt32) {
        var v = hex32
        let getDigits = {
            () -> UInt32 in

            v % 0xFF
        }
        let dropDigits = {
            () -> Void in

            v >>= 8
        }

        let a255 = getDigits()
        dropDigits()
        let b255 = getDigits()
        dropDigits()
        let g255 = getDigits()
        dropDigits()
        let r255 = getDigits()
        //dropDigits()

        self.init(
                red: CGFloat(r255) / 255,
                green: CGFloat(g255) / 255,
                blue: CGFloat(b255) / 255,
                alpha: CGFloat(a255) / 255
        )
    }

    convenience init(hex24: UInt32) {
        self.init(hex32: (hex24 << 8) + 0xFF)
    }
}

struct CSSColorParser {
    private init() {}

    static func fromHex(hex: String) -> UIColor? {
        return UIColor(hex: hex)
    }

    // https://developer.mozilla.org/ja/docs/Web/CSS/color_value
    static func fromKeyword(key: String) -> UIColor? {
        let c = {
            (hex: UInt32) -> UIColor? in

            UIColor(hex24: hex)
        }

        switch key.lowercased() {
        // CSS Level 1
        case "black":
            return c(0x000000)
        case "silver":
            return c(0xc0c0c0)
        case "gray":
            return c(0x808080)
        case "white":
            return c(0xffffff)
        case "maroon":
            return c(0x800000)
        case "red":
            return c(0xff0000)
        case "purple":
            return c(0x800080)
        case "fuchsia":
            return c(0xff00ff)
        case "green":
            return c(0x008000)
        case "lime":
            return c(0x00ff00)
        case "olive":
            return c(0x808000)
        case "yellow":
            return c(0xffff00)
        case "navy":
            return c(0x000080)
        case "blue":
            return c(0x0000ff)
        case "teal":
            return c(0x008080)
        case "aqua":
            return c(0x00ffff)

        // CSS Level 2 (Revision 1)
        case "orange":
            return c(0xffa500)
        default:
            return nil
        }
    }
}
