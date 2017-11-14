//
// Created by mopopo on 2017/11/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit

class StatusCell: UITableViewCell {
    static let reuseIdentifier = "Status"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StatusCell.reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class StatusCellOwner: NibViewOwner<StatusCell> {
    private var _status: Status!
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var displayNameLabel: UILabel!
    @IBOutlet weak private var userIdLabel: UILabel!
    @IBOutlet weak private var tootDateLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!

    private let _tootDateFormatter: DateFormatter
    
    private override init() {
        _tootDateFormatter = DateFormatter()
        _tootDateFormatter.dateStyle = .none
        _tootDateFormatter.timeStyle = .medium

        super.init()
    }

    convenience init(status: Status) {
        self.init()
        
        _status = status

        displayName = status.account.displayName
        userId = status.account.acct
        tootDate = status.createdAt
        content = status.content
    }

    var status: Status {
        return _status
    }

    var iconImage: UIImage? {
        get {
            return iconImageView.image
        }
        set {
            iconImageView.image = newValue
        }
    }

    var displayName: String? {
        get {
            return displayNameLabel.text
        }
        set {
            displayNameLabel.text = newValue
        }
    }

    var userId: String? {
        get {
            return userIdLabel.text
        }
        set {
            if newValue?.hasPrefix("@") ?? false {
                userIdLabel.text = newValue
            }
            else {
                userIdLabel.text = "@" + (newValue ?? "")
            }
        }
    }

    var tootDate: Date? {
        get {
            return _tootDateFormatter.date(from: tootDateLabel.text ?? "")
        }
        set {
            if let date = newValue {
                tootDateLabel.text = _tootDateFormatter.string(from: date)
            }
            else {
                tootDateLabel.text = nil
            }
        }
    }

    var content: String? {
        get {
            return contentLabel.text
        }
        set {
            contentLabel.text = newValue
        }
    }
}
