//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeLayoutManager: NSLayoutManager {
    override func showCGGlyphs(
            _ glyphs: UnsafePointer<CGGlyph>,
            positions: UnsafePointer<CGPoint>,
            count glyphCount: Int,
            font: UIFont,
            matrix textMatrix: CGAffineTransform,
            attributes: [NSAttributedStringKey: Any],
            in graphicsContext: CGContext) {

        super.showCGGlyphs(
                glyphs,
                positions: positions,
                count: glyphCount,
                font: font,
                matrix: textMatrix,
                attributes: attributes,
                in: graphicsContext
        )

        let glyphPosPairs = {
            () -> [(CGGlyph, CGPoint)] in

            var pairs: [(CGGlyph, CGPoint)] = []
            for i in 0 ..< glyphCount {
                pairs.append((glyphs[i], positions[i]))
            }

            return pairs
        }()

        let bbCodeAttrs = attributes.filter({BBCodeCustomAttrs.allValues.contains($0.key)})

        NSLog("[\(String(format: "%p", textStorage!))] showCGGlyphs(): BBCode attrs: \(bbCodeAttrs)\nglyph pos pairs: \(String(describing: glyphPosPairs))\n")
    }
}
