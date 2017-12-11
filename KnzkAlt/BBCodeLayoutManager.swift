//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeLayoutManager: NSLayoutManager {
    let contentView: UIView

    init(contentView: UIView) {
        self.contentView = contentView

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BBCodeLayoutManager does not support init?(coder:).")
    }

    override func showCGGlyphs(
            _ glyphs: UnsafePointer<CGGlyph>,
            positions: UnsafePointer<CGPoint>,
            count glyphCount: Int,
            font: UIFont,
            matrix textMatrix: CGAffineTransform,
            attributes: [NSAttributedStringKey: Any],
            in graphicsContext: CGContext) {

        let attrs = BBCodeCustomAttrs.rebuild(from: attributes)

        if attrs.bbCodeAttrs.isEmpty {
            super.showCGGlyphs(
                    glyphs,
                    positions: positions,
                    count: glyphCount,
                    font: font,
                    matrix: textMatrix,
                    attributes: attributes,
                    in: graphicsContext
            )
        }
        else {
            let glyphPosPairs = {
                () -> [(CGGlyph, CGPoint)] in

                var pairs: [(CGGlyph, CGPoint)] = []
                for i in 0 ..< glyphCount {
                    pairs.append((glyphs[i], positions[i]))
                }

                return pairs
            }()

            let bbCodeLayer = BBCodeLayer(
                    glyphPosPairs: glyphPosPairs,
                    font: font,
                    matrix: textMatrix,
                    bbCodeAttrs: attrs.bbCodeAttrs,
                    otherAttrs: attrs.otherAttrs
            )

            contentView.layer.addSublayer(bbCodeLayer)
            //contentView.setNeedsDisplay()

            //NSLog("[\(String(format: "%p", textStorage!))] showCGGlyphs(): \(bbCodeLayer.debugDescription)")
        }
    }
}
