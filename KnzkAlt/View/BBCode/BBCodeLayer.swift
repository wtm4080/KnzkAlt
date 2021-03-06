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
                let key = "spin"
                let a = CABasicAnimation(keyPath: "transform.rotation")
                a.delegate = BBCodeLayerAnimationDelegate(layer: self, animationKey: key)
                a.toValue = 2.0 * .pi
                a.duration = 2.0 / Double(factor)
                a.repeatCount = .infinity
                a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                add(a, forKey: key)

            case .pulse:
                let key = "pulse"
                let a = CABasicAnimation(keyPath: "opacity")
                a.delegate = BBCodeLayerAnimationDelegate(layer: self, animationKey: key)
                a.fromValue = 1.0
                a.toValue = 0.5 / Double(factor)
                a.duration = 1.0 / Double(factor)
                a.repeatCount = .infinity
                a.autoreverses = true
                a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                add(a, forKey: key)

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

    private var _detachedAnimations: [String: CAAnimation] = [:]

    fileprivate func addDetachedAnimation(a: CAAnimation, key: String) {
        _detachedAnimations[key] = a
    }

    func resumeAnimations() {
        _detachedAnimations.forEach {
            self.removeAnimation(forKey: $0.key)
            self.add($0.value, forKey: $0.key)
        }

        _detachedAnimations.removeAll()
    }
}

class BBCodeLayerAnimationDelegate: NSObject, CAAnimationDelegate {
    weak private var _layer: BBCodeLayer?
    let animationKey: String

    init(layer: BBCodeLayer, animationKey: String) {
        _layer = layer
        self.animationKey = animationKey
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag {
            _layer?.addDetachedAnimation(a: anim, key: animationKey)
        }
    }
}
