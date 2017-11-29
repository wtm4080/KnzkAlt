//
// Created by mopopo on 2017/11/27.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import Fuzi

class BBCodeView: UITextView {
    private let _textStorage = NSTextStorage()

    required init(frame: CGRect) {
//        let textContainer = NSTextContainer(size: frame.size)
//        textContainer.widthTracksTextView = true
//        textContainer.heightTracksTextView = true
//
//        super.init(frame: frame, textContainer: textContainer)
        super.init(frame: frame, textContainer: nil)

//        let layoutManager = BBCodeLayoutManager()
//        layoutManager.addTextContainer(textContainer)
//
//        _textStorage.addLayoutManager(layoutManager)

        isEditable = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BBCodeView does not support init?(coder:).")
    }

    override var intrinsicContentSize: CGSize {
        return bounds.size
    }

//    override var text: String! {
//        get {
//            return _textStorage.string
//        }
//        set {
//            _setTextStorage(contentHTML: newValue)
//
//            setNeedsLayout()
//        }
//    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }

//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//    }

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

        let s = NSMutableAttributedString()

        BBCodeView._traverseHTML(current: root, storage: s)

        set(s)
    }

    private static func _traverseHTML(current: XMLElement, storage: NSMutableAttributedString) {
        switch current.tag.map({ $0.lowercased() }) ?? "" {
//            case "p":
//                current.children.forEach {
//                    _traverseHTML(current: $0, storage: storage)
//                }
            default:
                storage.append(NSAttributedString(string: current.stringValue))
        }
    }
}

class BBCodeLayoutManager: NSLayoutManager {
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    }
}
