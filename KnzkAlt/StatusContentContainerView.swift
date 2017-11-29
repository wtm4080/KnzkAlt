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
}
