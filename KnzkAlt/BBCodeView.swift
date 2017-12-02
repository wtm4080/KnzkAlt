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
            current: XMLElement,
            currentTraversalDepth: Int = 0
    ) -> NSMutableAttributedString {

        let notParsed = { NSMutableAttributedString(string: current.stringValue) }

        guard currentTraversalDepth <= _maxHTMLTraversalDepth else {
            return notParsed()
        }

        let collectChildContents = {
            (children: [XMLElement], defaultValue: String) -> NSMutableAttributedString in

            guard !children.isEmpty else {
                return NSMutableAttributedString(string: defaultValue)
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

        let applyAttr = {
            (s: NSMutableAttributedString) in

            // ...
        }

        switch current.tag.map({ $0.lowercased() }) ?? "" {
            case "p":
                let s = collectChildContents(current.children, current.stringValue)

                applyAttr(s)

                return s
            default:
                return notParsed()
        }
    }
}

class BBCodeLayoutManager: NSLayoutManager {
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    }
}
