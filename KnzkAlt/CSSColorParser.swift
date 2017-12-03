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

        // CSS Color Module Level 3
        case "aliceblue":
            return c(0xf0f8ff)
        case "antiquewhite":
            return c(0xfaebd7)
        case "aquamarine":
            return c(0x7fffd4)
        case "azure":
            return c(0xf0ffff)
        case "beige":
            return c(0xf5f5dc)
        case "bisque":
            return c(0xffe4c4)
        case "blanchedalmond":
            return c(0xffebcd)
        case "blueviolet":
            return c(0x8a2be2)
        case "brown":
            return c(0xa52a2a)
        case "burlywood":
            return c(0xdeb887)
        case "cadetblue":
            return c(0x5f9ea0)
        case "chartreuse":
            return c(0x7fff00)
        case "chocolate":
            return c(0xd2691e)
        case "coral":
            return c(0xff7f50)
        case "cornflowerblue":
            return c(0x6495ed)
        case "cornsilk":
            return c(0xfff8dc)
        case "crimson":
            return c(0xdc143c)
        case "cyan":
            return c(0x00ffff)
        case "darkblue":
            return c(0x00008b)
        case "darkcyan":
            return c(0x008b8b)
        case "darkgoldenrod":
            return c(0xb8860b)
        case "darkgray":
            return c(0xa9a9a9)
        case "darkgreen":
            return c(0x006400)
        case "darkkhaki":
            return c(0xbdb76b)
        case "darkmagenta":
            return c(0x8b008b)
        case "darkolivegreen":
            return c(0x556b2f)
        case "darkorange":
            return c(0xff8c00)
        case "darkorchid":
            return c(0x9932cc)
        case "darkred":
            return c(0x8b0000)
        case "darksalmon":
            return c(0xe9967a)
        case "darkseagreen":
            return c(0x8fbc8f)
        case "darkslateblue":
            return c(0x483d8b)
        case "darkslategray":
            return c(0x2f4f4f)
        case "darkturquoise":
            return c(0x00ced1)
        case "darkviolet":
            return c(0x9400d3)
        case "deeppink":
            return c(0xff1493)
        case "deepskyblue":
            return c(0x00bfff)
        case "dimgray":
            return c(0x696969)
        case "dodgerblue":
            return c(0x1e90ff)
        case "firebrick":
            return c(0xb22222)
        case "floralwhite":
            return c(0xfffaf0)
        case "forestgreen":
            return c(0x228b22)
        case "gainsboro":
            return c(0xdcdcdc)
        case "ghostwhite":
            return c(0xf8f8ff)
        case "gold":
            return c(0xffd700)
        case "goldenrod":
            return c(0xdaa520)
        case "greenyellow":
            return c(0xadff2f)
        case "grey":
            return c(0x808080)
        case "honeydew":
            return c(0xf0fff0)
        case "hotpink":
            return c(0xff69b4)
        case "indianred":
            return c(0xcd5c5c)
        case "indigo":
            return c(0x4b0082)
        case "ivory":
            return c(0xfffff0)
        case "khaki":
            return c(0xf0e68c)
        case "lavender":
            return c(0xe6e6fa)
        case "lavenderblush":
            return c(0xfff0f5)
        case "lawngreen":
            return c(0x7cfc00)
        case "lemonchiffon":
            return c(0xfffacd)
        case "lightblue":
            return c(0xadd8e6)
        case "lightcoral":
            return c(0xf08080)
        case "lightcyan":
            return c(0xe0ffff)
        case "lightgoldenrodyellow":
            return c(0xfafad2)
        case "lightgray":
            return c(0xd3d3d3)
        case "lightgreen":
            return c(0x90ee90)
        case "lightpink":
            return c(0xffb6c1)
        case "lightsalmon":
            return c(0xffa07a)
        case "lightseagreen":
            return c(0x20b2aa)
        case "lightskyblue":
            return c(0x87cefa)
        case "lightslategray":
            return c(0x778899)
        case "lightsteelblue":
            return c(0xb0c4de)
        case "lightyellow":
            return c(0xffffe0)
        case "limegreen":
            return c(0x32cd32)
        case "linen":
            return c(0xfaf0e6)
        case "mediumaquamarine":
            return c(0x66cdaa)
        case "mediumblue":
            return c(0x0000cd)
        case "mediumorchid":
            return c(0xba55d3)
        case "mediumpurple":
            return c(0x9370db)
        case "mediumseagreen":
            return c(0x3cb371)
        case "mediumslateblue":
            return c(0x7b68ee)
        case "mediumspringgreen":
            return c(0x00fa9a)
        case "mediumturquoise":
            return c(0x48d1cc)
        case "mediumvioletred":
            return c(0xc71585)
        case "midnightblue":
            return c(0x191970)
        case "mintcream":
            return c(0xf5fffa)
        case "mistyrose":
            return c(0xffe4e1)
        case "moccasin":
            return c(0xffe4b5)
        case "navajowhite":
            return c(0xffdead)
        case "oldlace":
            return c(0xfdf5e6)
        case "olivedrab":
            return c(0x6b8e23)
        case "orangered":
            return c(0xff4500)
        case "orchid":
            return c(0xda70d6)
        case "palegoldenrod":
            return c(0xeee8aa)
        case "palegreen":
            return c(0x98fb98)
        case "paleturquoise":
            return c(0xafeeee)
        case "palevioletred":
            return c(0xdb7093)
        case "papayawhip":
            return c(0xffefd5)
        case "peachpuff":
            return c(0xffdab9)
        case "peru":
            return c(0xcd853f)
        case "pink":
            return c(0xffc0cb)
        case "plum":
            return c(0xdda0dd)
        case "powderblue":
            return c(0xb0e0e6)
        case "rosybrown":
            return c(0xbc8f8f)
        case "royalblue":
            return c(0x4169e1)
        case "saddlebrown":
            return c(0x8b4513)
        case "salmon":
            return c(0xfa8072)
        case "sandybrown":
            return c(0xf4a460)
        case "seagreen":
            return c(0x2e8b57)
        case "seashell":
            return c(0xfff5ee)
        case "sienna":
            return c(0xa0522d)
        case "skyblue":
            return c(0x87ceeb)
        case "slateblue":
            return c(0x6a5acd)
        case "slategray":
            return c(0x708090)
        case "snow":
            return c(0xfffafa)
        case "springgreen":
            return c(0x00ff7f)
        case "steelblue":
            return c(0x4682b4)
        case "tan":
            return c(0xd2b48c)
        case "thistle":
            return c(0xd8bfd8)
        case "tomato":
            return c(0xff6347)
        case "turquoise":
            return c(0x40e0d0)
        case "violet":
            return c(0xee82ee)
        case "wheat":
            return c(0xf5deb3)
        case "whitesmoke":
            return c(0xf5f5f5)
        case "yellowgreen":
            return c(0x9acd32)

        // CSS Color Module Level 4
        case "rebeccapurple":
            return c(0x663399)

        default:
            return nil
        }
    }
}
