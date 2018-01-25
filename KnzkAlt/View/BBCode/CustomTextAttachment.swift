//
// Created by mopopo on 2017/12/27.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class CustomTextAttachment: NSTextAttachment {
    override func attachmentBounds(
            for textContainer: NSTextContainer?,
            proposedLineFragment lineFrag: CGRect,
            glyphPosition position: CGPoint,
            characterIndex charIndex: Int
    ) -> CGRect {
        let defaultBounds = {
            () -> CGRect in

            let size = BBCodeView.defaultFont.pointSize

            return CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        }

        guard let storage = textContainer?.layoutManager?.textStorage else {
            return defaultBounds()
        }

        guard let font = storage.attribute(
                NSAttributedStringKey.font,
                at: charIndex,
                effectiveRange: nil
        ) as? UIFont else {
            return defaultBounds()
        }

        let size = font.pointSize

        guard size > 1 else {
            return defaultBounds()
        }

        return CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
    }
}
