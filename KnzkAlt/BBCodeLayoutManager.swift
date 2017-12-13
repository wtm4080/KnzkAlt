//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeLayoutManager: NSLayoutManager {
    let bbCodeView: BBCodeView

    init(bbCodeView: BBCodeView) {
        self.bbCodeView = bbCodeView

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

            let origin: () -> CGPoint = {
                var p = glyphPosPairs.first?.1 ?? CGPoint.zero

                // TODO: fix to convert appropriate coordinates
                p.y -= 12.0/15.0 * BBCodeView.defaultFontSize

                return p
            }

            let lastPosX = glyphPosPairs.last.map({$0.1.x - origin().x}) ?? 0.0
            let defaultBoundsSize = {
                () -> CGSize in

                let sizeUnit = font.ascender + font.descender

                return CGSize(
                        width: lastPosX + sizeUnit*2,
                        height: sizeUnit
                )
            }

            attrs.bbCodeAttrs.forEach {
                $0.value.boundingRectInContainer = CGRect(
                        origin: origin(),
                        size: defaultBoundsSize()
                )
            }

            DispatchQueue.main.async {
                [weak self] in

                self?.bbCodeView.constructBBCodeLayers()
            }

            //NSLog("[\(String(format: "%p", textStorage!))] showCGGlyphs(): \(bbCodeLayer.debugDescription)")
        }
    }
}
