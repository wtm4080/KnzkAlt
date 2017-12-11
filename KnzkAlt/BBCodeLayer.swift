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

        _setFrame()

        _setLayerProps()

        _setBBCodeProps()
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

        ctx.saveGState()
        defer {
            ctx.restoreGState()
        }

        _setDrawContextState(ctx: ctx)

        ctx.showGlyphs(
                local.map({$0.0}),
                at: local.map({$0.1})
        )

        _drawPostEffects(ctx: ctx)
    }

    private func _drawPostEffects(ctx: CGContext) {
        otherAttrs.forEach {
            ctx.saveGState()
            defer {
                ctx.restoreGState()
            }

            let uStyle = {
                (v: Any) -> NSUnderlineStyle in

                NSUnderlineStyle(rawValue: v as! Int) ?? .styleNone
            }

            let color = {
                (key: NSAttributedStringKey) -> UIColor? in

                self.otherAttrs[key] as? UIColor
            }

            switch $0.key {

            case NSAttributedStringKey.strikethroughStyle:
                _drawUnderline(
                        style: uStyle($0.value),
                        baseY: self.bounds.size.height/2,
                        color: color(NSAttributedStringKey.strikethroughColor),
                        ctx: ctx
                )

            case NSAttributedStringKey.underlineStyle:
                _drawUnderline(
                        style: uStyle($0.value),
                        baseY: self.fontToGetSize.ascender,
                        color: color(NSAttributedStringKey.underlineColor),
                        ctx: ctx)

            default:
                break
            }
        }
    }

    private func _drawUnderline(
            style: NSUnderlineStyle,
            baseY: CGFloat,
            color: UIColor?,
            ctx: CGContext
    ) {
        if style != .styleNone {
            if let color = color {
                ctx.setStrokeColor(color.cgColor)
            }

            let defaultLineWidth = CGFloat(2)

            let drawLine = {
                (beginY: [CGFloat]) -> () in

                beginY.forEach {
                    ctx.beginPath()
                    ctx.move(to: CGPoint(x: 0, y: $0))
                    ctx.addLine(to: CGPoint(x: self.bounds.size.width, y: $0))
                    ctx.strokePath()
                }
            }

            let height = bounds.size.height
            let centerY = height / 2

            switch style {

            case .styleSingle:
                ctx.setLineWidth(defaultLineWidth)
                drawLine([centerY])

            case .styleThick:
                ctx.setLineWidth(defaultLineWidth * 2)
                drawLine([centerY])

            case .styleDouble:
                ctx.setLineWidth(defaultLineWidth)

                let margin = height / 5
                drawLine([centerY + margin, centerY - margin])

            default:
                ctx.setLineWidth(defaultLineWidth)
                drawLine([centerY])
            }
        }
    }

    private func _setDrawContextState(ctx: CGContext) {
        ctx.setFont(BBCodeLayer._toCGFont(from: font))
        ctx.setLineWidth(3)

        var textMatrix = matrix
        textMatrix.tx = 0
        textMatrix.ty = 0

        otherAttrs.forEach {
            switch $0.key {

            case NSAttributedStringKey.font:
                ctx.setFont(BBCodeLayer._toCGFont(from: $0.value as! UIFont))

            case NSAttributedStringKey.foregroundColor:
                let color = ($0.value as! UIColor).cgColor
                ctx.setStrokeColor(color)
                ctx.setFillColor(color)

                if let strokeColor = otherAttrs[NSAttributedStringKey.strokeColor] as? UIColor {
                    ctx.setStrokeColor(strokeColor.cgColor)
                }

            case NSAttributedStringKey.shadow:
                let s = $0.value as! NSShadow
                ctx.setShadow(
                        offset: s.shadowOffset,
                        blur: s.shadowBlurRadius,
                        color: (s.shadowColor as! UIColor).cgColor
                )

            default:
                break
            }
        }
    }

    private func _setBBCodeProps() {
        bbCodeAttrs.forEach {
            let factor = $0.value.multiFactor

            let flipFactor = {
                CGFloat(factor % 2 == 0 ? 1.0 : -1.0)
            }

            switch $0.key {

            case .flipVertical:
                setAffineTransform(
                        affineTransform().scaledBy(x: 1.0, y: flipFactor())
                )
            case .flipHorizontal:
                setAffineTransform(
                        affineTransform().scaledBy(x: flipFactor(), y: 1.0)
                )

            case .spin:
                // TODO: apply spin animation
                break

            case .pulse:
                // TODO: apply pulse animation
                break

            default:
                NSLog("[Warning] Unrecognized BBCode attr on BBCodeLayer: \(String(describing: $0))")
            }
        }
    }

    private func _setLayerProps() {
        if bbCodeAttrs[.spin] != nil {
            allowsEdgeAntialiasing = true
            edgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
        }

        drawsAsynchronously = true

        cornerRadius = 1

        otherAttrs.forEach {
            switch $0.key {

            case NSAttributedStringKey.backgroundColor:
                backgroundColor = ($0.value as! UIColor).cgColor

            default:
                break
            }
        }
    }

    lazy var fontToGetSize: UIFont = {
        if let f = otherAttrs[NSAttributedStringKey.font] as? UIFont {
            return f
        }
        else {
            return font
        }
    }()

    private func _setFrame() {
        let fontToGetSize = self.fontToGetSize

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
            let cgFont = BBCodeLayer._toCGFont(from: fontToGetSize)

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

        frame = CGRect(
                origin: origin,
                size: boundsSize
        )
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
