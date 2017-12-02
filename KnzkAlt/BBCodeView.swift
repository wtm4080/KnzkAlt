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

    private func _setTextStorage(contentHTML: String) {
        let notParsed = { NSAttributedString(string: contentHTML) }

        let set: (NSAttributedString) -> Void = {
            [unowned self] in

            self._textStorage.setAttributedString($0)
        }

        guard let document = try? XMLDocument(string: contentHTML) else {
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

        if let element = current.toElement() {
            let tag = element.tag.map({ $0.lowercased() })

            switch tag ?? "" {

            case "p":
                let s = collectChildContents()

                applyAttrs(s, [:])

                return s

            case "br":
                return NSMutableAttributedString(string: "\n")

            case "a":
                let s = collectChildContents()

                guard let href = element.attributes["href"] else {
                    NSLog("[Warning] Cannot find href in <a>: \(current.rawXML)")

                    return s
                }

                guard let url = URL(string: href) else {
                    NSLog("[Warning] Cannot convert href to URL: \(current.rawXML)")

                    return s
                }

                applyAttrs(s, [
                    NSAttributedStringKey.link: url,
                    NSAttributedStringKey.foregroundColor: UIColor.blue
                ])

                return s

            default:
                NSLog("[Warning] Unrecognized HTML tag: \(current.rawXML)")

                return notParsed()
            }
        }
        else {
            return notParsed()
        }
    }
}

class BBCodeLayoutManager: NSLayoutManager {
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)

        //NSLog("Attrs: \(textStorage?.attributes(at: glyphsToShow.location, effectiveRange: nil))")
    }
}
