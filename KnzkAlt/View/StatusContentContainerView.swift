//
// Created by mopopo on 2017/11/29.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class StatusContentContainerView: UIStackView {
    private var _bbCodeView: BBCodeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 8
        
        _bbCodeView = BBCodeView(frame: bounds)
        
        addArrangedSubview(_bbCodeView)
    }

    var bbCodeView: BBCodeView {
        get {
            return _bbCodeView
        }
    }

    func addMedia(videoURL: URL?, isNSFW: Bool) -> MediaView {
        let mediaView = MediaView(
                frame: CGRect(
                        origin: CGPoint.zero,
                        size: CGSize(
                                width: bounds.size.width,
                                height: bounds.size.width/16 * 9
                        )
                ),
                videoURL: videoURL,
                isNSFW: isNSFW
        )

        addArrangedSubview(mediaView)

        return mediaView
    }
}
