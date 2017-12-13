//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeLayer: CALayer {
    let bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue]
    let otherAttrs: [NSAttributedStringKey: Any]

    init(
            stringToDraw: String,
            position: CGPoint,
            bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue],
            otherAttrs: [NSAttributedStringKey: Any]
    ) {
        self.bbCodeAttrs = bbCodeAttrs
        self.otherAttrs = otherAttrs

        super.init()

        let sToDraw = stringToDraw as NSString

        self.frame = CGRect(
                origin: position,
                size: sToDraw.size(withAttributes: otherAttrs)
        )

        _init()

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        sToDraw.draw(in: bounds, withAttributes: otherAttrs)

        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            contents = image.cgImage
        }
        else {
            borderColor = UIColor.black.cgColor
            borderWidth = 1
        }
    }

    override init(layer: Any) {
        if let other = layer as? BBCodeLayer {
            self.bbCodeAttrs = other.bbCodeAttrs
            self.otherAttrs = other.otherAttrs
        }
        else {
            self.bbCodeAttrs = [:]
            self.otherAttrs = [:]
        }

        super.init(layer: layer)

        _init()
    }

    private func _init() {
        _setLayerProps()

        _setBBCodeProps()

        needsDisplayOnBoundsChange = true
        setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BBCodeLayer does not support init?(coder:).")
    }

    override var debugDescription: String {
        return "BBCodeLayer: BBCode attrs: \(bbCodeAttrs)\nother attrs: \(String(describing: otherAttrs))\n"
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
    }
}
