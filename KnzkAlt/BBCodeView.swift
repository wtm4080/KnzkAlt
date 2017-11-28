//
// Created by mopopo on 2017/11/27.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeView: UITextView {
    private let _textStorage: NSTextStorage

    required init(frame: CGRect, content: String, isEditable: Bool = false) {
        _textStorage = BBCodeView._createTextStorage(contentHTML: content)

        let textContainer = NSTextContainer(size: frame.size)
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true

        let layoutManager = BBCodeLayoutManager()
        layoutManager.addTextContainer(textContainer)
        _textStorage.addLayoutManager(layoutManager)

        super.init(frame: frame, textContainer: textContainer)

        self.isEditable = isEditable
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BBCodeView does not support init(coder:).")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    private static func _createTextStorage(contentHTML: String) -> NSTextStorage {
        return NSTextStorage(string: contentHTML)
    }
}

class BBCodeLayoutManager: NSLayoutManager {
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    }
}
