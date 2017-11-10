//
// Created by mopopo on 2017/11/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    static let reuseIdentifier = "Status"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StatusCell.reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class StatusCellOwner: NSObject {
    private var _cell: StatusCell!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tootDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override init() {
        super.init()

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: StatusCell.self), bundle: bundle)
        _cell = nib.instantiate(withOwner: self).first as! StatusCell
    }

    var cell: StatusCell {
        return _cell
    }
}
