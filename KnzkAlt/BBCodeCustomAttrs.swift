//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

enum BBCodeCustomAttrs: String {
    case flipVertical = "BBCode.FlipVertical"
    case flipHorizontal = "BBCode.FlipHorizontal"
    case spin = "BBCode.Spin"
    case pulse = "BBCode.Pulse"
    case quote = "BBCode.Quote"
    case code = "BBCode.Code"

    static func rebuild(
            from attrs: [NSAttributedStringKey: Any]
    ) -> (bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue], otherAttrs: [NSAttributedStringKey: Any]) {

        var bbCodeAttrs = [BBCodeCustomAttrs: BBCodeCustomValue]()
        var otherAttrs = [NSAttributedStringKey: Any]()

        attrs.forEach {
            switch $0.key.rawValue {
            case
                    BBCodeCustomAttrs.flipVertical.rawValue,
                    BBCodeCustomAttrs.flipHorizontal.rawValue,
                    BBCodeCustomAttrs.spin.rawValue,
                    BBCodeCustomAttrs.pulse.rawValue,
                    BBCodeCustomAttrs.quote.rawValue,
                    BBCodeCustomAttrs.code.rawValue:
                bbCodeAttrs[BBCodeCustomAttrs(rawValue: $0.key.rawValue)!] = ($0.value as? BBCodeCustomValue)!
            default:
                otherAttrs[$0.key] = $0.value
            }
        }

        return (bbCodeAttrs: bbCodeAttrs, otherAttrs: otherAttrs)
    }

    var attrKey: NSAttributedStringKey {
        return NSAttributedStringKey(rawValue)
    }

    static func htmlStyleToAttrsDict(
            htmlStyle: String,
            classAttr: String,
            tagName: String
    ) -> [NSAttributedStringKey: Any] {

        guard !htmlStyle.isEmpty || !classAttr.isEmpty else {
            return [:]
        }

        var styles = HTMLStyleParser(rawValue: htmlStyle)
        var classAttrs = HTMLClassParser(rawValue: classAttr)

        var attrs: [NSAttributedStringKey: Any] = [:]

        var handledAttrsLogger = HandledAttrsLogger()

        if let c = styles.foregroundColor {
            attrs[NSAttributedStringKey.foregroundColor] = c
        }
        handledAttrsLogger.markAsHandled(attr: styles.foregroundColorKey)

        let fontSize = styles.fontSize.map({$0 * (classAttrs.largeRate ?? 1.0)})
        handledAttrsLogger.markAsHandled(attr: styles.fontSizeKey)

        if styles.isItalic {
            attrs[NSAttributedStringKey.font] = UIFont.italicSystemFont(
                    ofSize: fontSize ?? BBCodeView.defaultFontSize
            )

            handledAttrsLogger.markAsHandled(attr: styles.isItalicKey)
        }
        else if let fontWeight = styles.fontWeight {
            attrs[NSAttributedStringKey.font] = UIFont.systemFont(
                    ofSize: fontSize ?? BBCodeView.defaultFontSize,
                    weight: fontWeight
            )

            handledAttrsLogger.markAsHandled(attr: styles.fontWeightKey)
        }
        else if let fontSize = fontSize {
            attrs[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: fontSize)
        }
        else if let largeLate = classAttrs.largeRate {
            attrs[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: BBCodeView.defaultFontSize * largeLate)
        }
        else {
            // no-op
        }
        handledAttrsLogger.markAsHandled(attr: "font-family")
        handledAttrsLogger.markAsHandled(attr: "-webkit-font-feature-settings")
        handledAttrsLogger.markAsHandled(attr: "-moz-font-feature-settings")
        handledAttrsLogger.markAsHandled(attr: "font-feature-settings")

        if let isStrikethrough = styles.isStrikethrough, isStrikethrough {
            attrs[NSAttributedStringKey.strikethroughStyle] = NSUnderlineStyle.styleSingle.rawValue

            handledAttrsLogger.markAsHandled(attr: styles.isStrikethroughKey)
        }

        if classAttrs.isFlipVertical {
            attrs[BBCodeCustomAttrs.flipVertical.attrKey] = BBCodeCustomValue()
        }

        if classAttrs.isFlipHorizontal {
            attrs[BBCodeCustomAttrs.flipHorizontal.attrKey] = BBCodeCustomValue()
        }

        if classAttrs.isSpin {
            attrs[BBCodeCustomAttrs.spin.attrKey] = BBCodeCustomValue()
        }

        handledAttrsLogger.logUnhandledAttrs(
                allAttrs: styles.keyValues,
                tagName: tagName + ".style"
        )

        var handledClassAttrsLogger = HandledAttrsLogger()
        handledClassAttrsLogger.markAsHandled(attrs: classAttrs.processedAttrs)
        handledClassAttrsLogger.logUnhandledAttrs(
                allAttrs: classAttrs.keys,
                tagName: tagName + ".class"
        )

        return attrs
    }
}
