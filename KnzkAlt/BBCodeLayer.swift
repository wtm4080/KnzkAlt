//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeLayer: CALayer {
    let glyphPosPairs: [(CGGlyph, CGPoint)]
    let font: UIFont
    let matrix: CGAffineTransform
    let bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue]
    let otherAttrs: [NSAttributedStringKey: Any]

    init(
            glyphPosPairs: [(CGGlyph, CGPoint)],
            font: UIFont,
            matrix: CGAffineTransform,
            bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue],
            otherAttrs: [NSAttributedStringKey: Any]
    ) {
        self.glyphPosPairs = glyphPosPairs
        self.font = font
        self.matrix = matrix
        self.bbCodeAttrs = bbCodeAttrs
        self.otherAttrs = otherAttrs

        super.init()
    }

    private func _setBounds() {
        let fontToGetSize: UIFont
        if let f = otherAttrs[NSAttributedStringKey.font] as? UIFont {
            fontToGetSize = f
        }
        else {
            fontToGetSize = font
        }

        let lastPosX = glyphPosPairs.last.map({$0.1.x - origin.x}) ?? 0.0

        let defaultBoundsSize = {
            () -> CGSize in

            let sizeUnit = fontToGetSize.ascender + fontToGetSize.descender

            return CGSize(
                    width: lastPosX + sizeUnit,
                    height: sizeUnit
            )
        }

        let boundsSize: CGSize
        if var lastGlyph = glyphPosPairs.last?.0 {
            let ctFont = CTFontCreateWithFontDescriptor(
                    fontToGetSize.fontDescriptor as CTFontDescriptor,
                    fontToGetSize.pointSize,
                    nil
            )
            let cgFont = CTFontCopyGraphicsFont(ctFont, nil)

            let pBoundingBox = UnsafeMutablePointer<CGRect>.allocate(capacity: 1)

            let result = cgFont.getGlyphBBoxes(
                    glyphs: &lastGlyph,
                    count: 1,
                    bboxes: pBoundingBox
            )

            if result {
                let lastGlyphSize = pBoundingBox[0].size

                boundsSize = CGSize(
                        width: lastPosX + lastGlyphSize.width,
                        height: lastGlyphSize.height
                )
            }
            else {
                boundsSize = defaultBoundsSize()
            }
        }
        else {
            boundsSize = defaultBoundsSize()
        }

        bounds = CGRect(
                origin: CGPoint.zero,
                size: boundsSize
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BBCodeLayer does not support init?(coder:).")
    }

    override var debugDescription: String {
        return "BBCodeLayer: BBCode attrs: \(bbCodeAttrs)\nglyph pos pairs: \(String(describing: glyphPosPairs))\nother attrs: \(String(describing: otherAttrs))\n"
    }

    lazy var origin: CGPoint = {
        return glyphPosPairs.first?.1 ?? CGPoint.zero
    }()

    override func draw(in ctx: CGContext) {
        let toLocalPos = {
            [unowned self] (p: CGPoint) -> CGPoint in

            let o = self.origin

            return CGPoint(x: p.x - o.x, y: p.y - o.y)
        }

        let local = glyphPosPairs.map({($0.0, toLocalPos($0.1))})
    }
}
