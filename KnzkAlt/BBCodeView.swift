//
// Created by mopopo on 2017/11/27.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import Fuzi

class BBCodeView: UITextView {
    private let _textStorage = NSTextStorage()

    required init(frame: CGRect) {
        let textContainer = NSTextContainer(size: frame.size)
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true

        super.init(frame: frame, textContainer: textContainer)

        let layoutManager = BBCodeLayoutManager()
        layoutManager.addTextContainer(textContainer)

        _textStorage.addLayoutManager(layoutManager)

        isEditable = false
        textContainerInset = UIEdgeInsets.zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BBCodeView does not support init?(coder:).")
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override var text: String! {
        get {
            return _textStorage.string
        }
        set {
            super.text = newValue

            _setTextStorage(contentHTML: newValue)

            invalidateIntrinsicContentSize()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    private static let _contentRootTag = "__content_root__"

    private func _setTextStorage(contentHTML: String) {
        let notParsed = { NSAttributedString(string: contentHTML) }

        let set: (NSAttributedString) -> Void = {
            [unowned self] in

            self._textStorage.setAttributedString($0)
        }

        let enclosedContent = "<\(BBCodeView._contentRootTag)>\(contentHTML)</\(BBCodeView._contentRootTag)>"

        guard let document = try? XMLDocument(string: enclosedContent) else {
            set(notParsed())

            return
        }

        guard let root = document.root else {
            set(notParsed())

            return
        }

        set(BBCodeView._traverseHTML(current: root))
    }

    private static let _maxHTMLTraversalDepth = 50

    static let defaultFontSize = CGFloat(15)
    static let defaultFont = UIFont.systemFont(ofSize: defaultFontSize)

    private static func _traverseHTML(
            current: XMLNode,
            currentTraversalDepth: Int = 0
    ) -> NSMutableAttributedString {

        let notParsed = { NSMutableAttributedString(string: current.stringValue) }

        guard currentTraversalDepth <= _maxHTMLTraversalDepth else {
            return notParsed()
        }

        let collectChildContents = {
            () -> NSMutableAttributedString in

            let defaultResult = { NSMutableAttributedString(string: current.stringValue) }

            guard let children = current.toElement()?.childNodes(ofTypes: [.Element, .Text]) else {
                return defaultResult()
            }

            guard !children.isEmpty else {
                return defaultResult()
            }

            let s = NSMutableAttributedString()

            children.forEach {
                s.append(
                        _traverseHTML(
                                current: $0,
                                currentTraversalDepth: currentTraversalDepth + 1
                        )
                )
            }

            return s
        }

        let applyAttrs = {
            (s: NSMutableAttributedString, attrs: [NSAttributedStringKey: Any]) in

            guard s.length > 0 && !attrs.isEmpty else {
                return
            }

            s.addAttributes(attrs, range: NSRange(location: 0, length: s.length))
        }

        let elementToTag = {
            (element: XMLElement) -> String in

            return element.tag.map({ $0.lowercased() }) ?? ""
        }

        let handleElement = {
            (element: XMLElement) -> NSMutableAttributedString in

            let attrs = _htmlAttrsToAttrsDict(
                    tag: elementToTag(element),
                    htmlAttrs: element.attributes
            )

            let s = collectChildContents()

            applyAttrs(s, attrs)

            return s
        }

        if let element = current.toElement() {
            let tag = elementToTag(element);

            let handleAsDefault = {
                () -> NSMutableAttributedString in

                switch tag {

                case _contentRootTag, "p", "a", "span", "u":
                    return handleElement(element)

                case "br":
                    return NSMutableAttributedString(string: "\n")

                default:
                    NSLog("[Warning] Unrecognized HTML tag: \(current.rawXML)")

                    return notParsed()
                }
            }

            if tag == "span", let classAttr = element.attributes["class"] {
                switch classAttr {
                    case "invisible":
                        return NSMutableAttributedString()
                    case "ellipsis":
                        let handled = handleAsDefault()
                        handled.append(NSAttributedString(string: "..."))

                        return handled
                    default:
                        return handleAsDefault()
                }
            }
            else {
                return handleAsDefault()
            }
        }
        else {
            let s = notParsed()
            s.addAttribute(
                    NSAttributedStringKey.font,
                    value: BBCodeView.defaultFont,
                    range: NSRange(location: 0, length: s.length)
            )

            return s
        }
    }

    private static func _htmlAttrsToAttrsDict(
            tag: String,
            htmlAttrs: [String: String]
    ) -> [NSAttributedStringKey: Any] {

        var handledAttrsLogger = HandledAttrsLogger()

        let result: [NSAttributedStringKey: Any]
        switch tag {

        case _contentRootTag, "p":
            result = [:]

        case "a":
            let hrefAttrs = {
                () -> [NSAttributedStringKey: Any] in

                let hrefAttr = "href"

                guard let href = htmlAttrs[hrefAttr] else {
                    NSLog("[Warning] Cannot find href in <a>: \(String(describing: htmlAttrs))")

                    return [:]
                }

                guard let url = URL(string: href) else {
                    NSLog("[Warning] Cannot convert href to URL in <a>: \(String(describing: htmlAttrs))")

                    return [:]
                }

                handledAttrsLogger.markAsHandled(attr: hrefAttr)

                return [NSAttributedStringKey.link: url]
            }

            // ignoring
            handledAttrsLogger.markAsHandled(attr: "rel")
            handledAttrsLogger.markAsHandled(attr: "target")

            result = hrefAttrs()

        case "span":
            // ignoring
            if let classAttr = htmlAttrs["class"], classAttr == "ellipsis" || classAttr == "" {
                handledAttrsLogger.markAsHandled(attr: "class")
            }

            let styleAttr = "style"
            let styleAttrs = BBCodeCustomAttrs.htmlStyleToAttrsDict(
                    htmlStyle: htmlAttrs[styleAttr] ?? "",
                    tagName: tag
            )
            handledAttrsLogger.markAsHandled(attr: styleAttr)

            result = styleAttrs

        case "u":
            result = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]

        default:
            NSLog("[Warning] Unrecognized tag for converting html attrs to attrs dict:\ntag: \(tag), htmlAttrs: \(String(describing: htmlAttrs))")

            return [:]
        }

        handledAttrsLogger.logUnhandledAttrs(allAttrs: htmlAttrs, tagName: tag)

        return result
    }
}

struct HandledAttrsLogger {
    private var _handledAttrs = Set<String>()

    mutating func markAsHandled(attr: String) {
        _handledAttrs.insert(attr)
    }

    func logUnhandledAttrs(allAttrs: [String: Any], tagName: String) {
        let unhandled = allAttrs.filter { !_handledAttrs.contains($0.key) }

        unhandled.forEach {
            NSLog("[Warning] Unhandled HTML attr for <\(tagName)> tag: \(String(describing: $0))")
        }
    }
}

class BBCodeLayoutManager: NSLayoutManager {
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)

        //NSLog("Attrs: \(textStorage?.attributes(at: glyphsToShow.location, effectiveRange: nil))")
    }
}

enum BBCodeCustomAttrs {
    static func htmlStyleToAttrsDict(
            htmlStyle: String,
            tagName: String
    ) -> [NSAttributedStringKey: Any] {

        guard !htmlStyle.isEmpty else {
            return [:]
        }

        var styles = HTMLStyleParser(rawValue: htmlStyle)

        var attrs: [NSAttributedStringKey: Any] = [:]

        var handledAttrsLogger = HandledAttrsLogger()

        if let c = styles.foregroundColor {
            attrs[NSAttributedStringKey.foregroundColor] = c
        }
        handledAttrsLogger.markAsHandled(attr: styles.foregroundColorKey)

        if styles.isItalic {
            attrs[NSAttributedStringKey.font] = UIFont.italicSystemFont(ofSize: BBCodeView.defaultFontSize)

            handledAttrsLogger.markAsHandled(attr: styles.isItalicKey)
        }
        else if let fontWeight = styles.fontWeight {
            attrs[NSAttributedStringKey.font] = UIFont.systemFont(
                    ofSize: BBCodeView.defaultFontSize,
                    weight: fontWeight
            )

            handledAttrsLogger.markAsHandled(attr: styles.fontWeightKey)
        }
        else {
            // no-op
        }
        handledAttrsLogger.markAsHandled(attr: "font-family")
        handledAttrsLogger.markAsHandled(attr: "-webkit-font-feature-settings")
        handledAttrsLogger.markAsHandled(attr: "-moz-font-feature-settings")
        handledAttrsLogger.markAsHandled(attr: "font-feature-settings")

        handledAttrsLogger.logUnhandledAttrs(
                allAttrs: styles.keyValues,
                tagName: tagName + ".style"
        )

        return attrs
    }
}
