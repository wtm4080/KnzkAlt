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

            var v = rawValue
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
        else {
            return nil
        }
    }
}

struct CSSColorParser {
}
