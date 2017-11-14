//
// Created by mopopo on 2017/11/14.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class NibViewOwner<V: UIView>: NSObject {
    private var _view: V!

    override init() {
        super.init()

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: V.self), bundle: bundle)
        _view = nib.instantiate(withOwner: self).first as! V
    }

    var view: V {
        return _view
    }
}
