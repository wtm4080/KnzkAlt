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

//    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
//        let bbCodeCharsRange = characterRange(
//                forGlyphRange: glyphsToShow,
//                actualGlyphRange: nil
//        )
//
//        let rawAttrs = textStorage!
//                .attributedSubstring(from: bbCodeCharsRange)
//                .attributes(
//                        at: 0,
//                        longestEffectiveRange: nil,
//                        in: bbCodeCharsRange
//                )
//
//        let attrs = BBCodeCustomAttrs.rebuild(from: rawAttrs)
//
//        if attrs.bbCodeAttrs.isEmpty {
//            super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
//        }
//        else {
//            let rect = boundingRect(
//                    forGlyphRange: glyphsToShow,
//                    in: textContainers[0]
//            )
//
//            attrs.bbCodeAttrs.forEach {
//                $0.value.boundingRectInContainer = rect
//            }
//        }
//    }

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
                glyphPosPairs.first?.1 ?? CGPoint.zero
            }

            let lastPosX = glyphPosPairs.last.map({$0.1.x - origin().x}) ?? 0.0
            let defaultBoundsSize = {
                () -> CGSize in

                let sizeUnit = font.ascender + font.descender

                return CGSize(
                        width: lastPosX + sizeUnit,
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

            return

//            let bbCodeCharsRange = characterRange(
//                    forGlyphRange: glyphsToShow,
//                    actualGlyphRange: nil
//            )
//
//            let rect = boundingRect(
//                    forGlyphRange: glyphsToShow,
//                    in: textContainers[0]
//            )
//
//            attrs.bbCodeAttrs.forEach {
//                $0.value.boundingRectInContainer = rect
//            }

            //NSLog("graphicsContext: \(String(describing: graphicsContext))")
//
//            let bbCodeLayer = BBCodeLayer(
//                    glyphPosPairs: glyphPosPairs,
//                    font: font,
//                    matrix: textMatrix,
//                    bbCodeAttrs: attrs.bbCodeAttrs,
//                    otherAttrs: attrs.otherAttrs
//            )
//
//            contentView.layer.addSublayer(bbCodeLayer)
            //contentView.setNeedsDisplay()

//            UIGraphicsBeginImageContext(defaultBoundsSize())
//            defer {
//                UIGraphicsEndImageContext()
//            }
//            let imageContext = UIGraphicsGetCurrentContext()!
//            imageContext.setFont(BBCodeLayoutManager._toCGFont(from: font))
//            imageContext.textMatrix = textMatrix
//
//            super.showCGGlyphs(
//                    glyphs,
//                    positions: glyphPosPairs.map({$0.1}),
//                    count: glyphCount,
//                    font: font,
//                    matrix: textMatrix,
//                    attributes: attributes,
//                    in: imageContext
//                    //in: graphicsContext
//            )
//
//            if let image = UIGraphicsGetImageFromCurrentImageContext() {
//                let layer = CALayer()
//                layer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: defaultBoundsSize())
//                layer.contents = image.cgImage
//                layer.borderWidth = 1
//                layer.borderColor = UIColor.black.cgColor
//
//                layer.needsDisplayOnBoundsChange = true
//                layer.setNeedsDisplay()
//
//                contentView.layer.addSublayer(layer)
//
////                let imageView = UIImageView(image: image)
////                contentView.addSubview(imageView)
//            }

            //NSLog("[\(String(format: "%p", textStorage!))] showCGGlyphs(): \(bbCodeLayer.debugDescription)")
        }
    }

    private static func _toCGFont(from f: UIFont) -> CGFont {
        let ctFont = CTFontCreateWithFontDescriptor(
                f.fontDescriptor as CTFontDescriptor,
                f.pointSize,
                nil
        )

        return CTFontCopyGraphicsFont(ctFont, nil)
    }
}
