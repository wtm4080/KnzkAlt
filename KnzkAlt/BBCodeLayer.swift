//
// Created by mopopo on 2017/12/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class BBCodeLayer: CALayer {
    let glyphPosPairs: [(CGGlyph, CGPoint)]
    let matrix: CGAffineTransform
    let bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue]
    let otherAttrs: [NSAttributedStringKey: Any]

    init(
            glyphPosPairs: [(CGGlyph, CGPoint)],
            matrix: CGAffineTransform,
            bbCodeAttrs: [BBCodeCustomAttrs: BBCodeCustomValue],
            otherAttrs: [NSAttributedStringKey: Any]
    ) {
        self.glyphPosPairs = glyphPosPairs
        self.matrix = matrix
        self.bbCodeAttrs = bbCodeAttrs
        self.otherAttrs = otherAttrs

        super.init()
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
