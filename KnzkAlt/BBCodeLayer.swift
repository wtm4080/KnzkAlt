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
}
