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

        let layoutManager = BBCodeLayoutManager(bbCodeView: self)
        layoutManager.addTextContainer(textContainer)

        _textStorage.addLayoutManager(layoutManager)

        isEditable = false
        textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
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

    func constructBBCodeLayers() {
        _textStorage.enumerateAttributes(
                in: NSRange(
                        location: 0,
                        length: _textStorage.length
                )
        ) {
            rawAttrs, charRange, _ in

            let attrs = BBCodeCustomAttrs.rebuild(from: rawAttrs)

            guard !attrs.bbCodeAttrs.isEmpty else {
                return
            }

            guard let boundingRect = attrs.bbCodeAttrs.first?.value.boundingRectInContainer else {
                return
            }

            let stringToDraw = _textStorage.attributedSubstring(from: charRange).string

            let layer = BBCodeLayer(
                    stringToDraw: stringToDraw,
                    position: boundingRect.origin,
                    bbCodeAttrs: attrs.bbCodeAttrs,
                    otherAttrs: attrs.otherAttrs
            )

            self.subviews[0].layer.addSublayer(layer)
        }
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
            currentTraversalDepth: UInt = 0
    ) -> NSMutableAttributedString {

        let notParsed = { NSMutableAttributedString(string: current.stringValue) }

        guard currentTraversalDepth <= _maxHTMLTraversalDepth else {
            return notParsed()
        }

        let children = current.toElement()?.childNodes(ofTypes: [.Element, .Text])

        let collectChildContents = {
            () -> NSMutableAttributedString in

            let defaultResult = { NSMutableAttributedString(string: current.stringValue) }

            guard let children = children else {
                return defaultResult()
            }

            guard !children.isEmpty else {
                return defaultResult()
            }

            let traverse = {
                (childNode: XMLNode) -> NSMutableAttributedString in

                return _traverseHTML(
                        current: childNode,
                        currentTraversalDepth: currentTraversalDepth + 1
                )
            }

            let s = NSMutableAttributedString()

            children.forEach {
                s.append(traverse($0))
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

            var attrs = _htmlAttrsToAttrsDict(
                    tag: elementToTag(element),
                    htmlAttrs: element.attributes
            )

            let collectedChildContents = collectChildContents()

            // if current node has only one child element,
            // merge their BBCode values
            if let children = children, children.count == 1 && children[0].toElement() != nil {
                let childAttrs = collectedChildContents.attributes(
                        at: 0,
                        longestEffectiveRange: nil,
                        in: NSRange(location: 0, length: collectedChildContents.length)
                )

                var duplicatedBBCodeAttrs: [NSAttributedStringKey: (current: BBCodeCustomValue, child: BBCodeCustomValue)] = [:]
                childAttrs.forEach {
                    let childKV = $0

                    if
                            let currentV = attrs[childKV.key] as? BBCodeCustomValue,
                            let childV = childKV.value as? BBCodeCustomValue {
                        duplicatedBBCodeAttrs[childKV.key] = (current: currentV, child: childV)
                    }
                }

                duplicatedBBCodeAttrs.forEach {
                    collectedChildContents.removeAttribute(
                            $0.key,
                            range: NSRange(location: 0, length: collectedChildContents.length)
                    )

                    attrs[$0.key] = $0.value.current.merging(other: $0.value.child)
                }
            }

            applyAttrs(collectedChildContents, attrs)

            return collectedChildContents
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
            var s = current.stringValue
            let replace = {
                (from: String, to: String) -> Void in

                s = s.replacingOccurrences(of: from, with: to)
            }

            // https://developer.mozilla.org/en-US/docs/Glossary/Entity
            replace("&amp;", "&")
            replace("&lt;", "<")
            replace("&gt;", ">")
            replace("&quot;", "\"")

            let attributed = NSMutableAttributedString(string: s)
            attributed.addAttribute(
                    NSAttributedStringKey.font,
                    value: BBCodeView.defaultFont,
                    range: NSRange(location: 0, length: attributed.length)
            )

            return attributed
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
            let classAttr = "class"
            if let classAttrValue = htmlAttrs[classAttr], classAttrValue == "ellipsis" || classAttrValue == "" {
                handledAttrsLogger.markAsHandled(attr: classAttr)
            }

            let styleAttr = "style"
            let styleAttrs = BBCodeCustomAttrs.htmlStyleToAttrsDict(
                    htmlStyle: htmlAttrs[styleAttr] ?? "",
                    classAttr: htmlAttrs[classAttr] ?? "",
                    tagName: tag
            )
            handledAttrsLogger.markAsHandled(attr: styleAttr)
            handledAttrsLogger.markAsHandled(attr: classAttr)

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
