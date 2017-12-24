//
// Created by mopopo on 2017/11/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit

class StatusCell: UITableViewCell {
    static let reuseIdentifier = "Status"

    weak var owner: StatusCellOwner?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StatusCell.reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var cellHeight: CGFloat = {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        return size.height
    }()

    func resumeBBCodeAnimations() {
        guard let owner = self.owner else {
            return
        }

        owner.resumeBBCodeAnimations()
    }
}

class StatusCellOwner: NibViewOwner<StatusCell> {
    private var _status: Status!
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var displayNameLabel: UILabel!
    @IBOutlet weak private var userIdLabel: UILabel!
    @IBOutlet weak private var tootDateLabel: UILabel!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var btByLabel: UILabel!
    @IBOutlet weak private var btByImageView: UIImageView!
    @IBOutlet weak private var btButton: UIButton!
    @IBOutlet weak private var favButton: UIButton!
    
    private let _tootDateFormatter: DateFormatter
    
    private override init() {
        _tootDateFormatter = DateFormatter()
        _tootDateFormatter.dateStyle = .none
        _tootDateFormatter.timeStyle = .medium

        super.init()
    }

    convenience init(status: Status) {
        self.init()

        view.owner = self
        
        _status = status

        let setProps = {
            [unowned self] (s: Status) in

            self.displayName = s.account.displayName
            self.userId = s.account.acct
            self.tootDate = s.createdAt
            self.content = s.content

            switch s.visibility {
                case .public, .unlisted:
                    self.btButton.isEnabled = true
                    self.btButton.isSelected = s.reblogged ?? false
                case .private, .direct:
                    self.btButton.isEnabled = false
            }

            self.favButton.isSelected = s.favourited ?? false
        }

        if let reblogStatus = status.reblog {
            setProps(reblogStatus)

            btByLabel.isHidden = false
            btByImageView.isHidden = false

            IconStorage.shared.loadIcon(
                    url: URL(string: reblogStatus.account.avatar)!,
                    for: self)
            IconStorage.shared.loadBtByIcon(
                    url: URL(string: status.account.avatar)!,
                    for: self)
        }
        else {
            setProps(status)

            IconStorage.shared.loadIcon(
                    url: URL(string: status.account.avatar)!,
                    for: self)
        }

        let imageCornerRadius = CGFloat(4)
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = imageCornerRadius
        btByImageView.clipsToBounds = true
        btByImageView.layer.cornerRadius = imageCornerRadius

        let gestureForStatusDetail = UITapGestureRecognizer(
                target: self,
                action: #selector(type(of: self)._statusDetailAction(sender:))
        )
        bbCodeView.addGestureRecognizer(gestureForStatusDetail)

        let gestureForAccountDetail = UITapGestureRecognizer(
                target: self,
                action: #selector(type(of: self)._accountDetailAction(sender:))
        )
        iconImageView.addGestureRecognizer(gestureForAccountDetail)

        let gestureForBTByAccountDetail = UITapGestureRecognizer(
                target: self,
                action: #selector(type(of: self)._btAccountDetailAction(sender:))
        )
        btByImageView.addGestureRecognizer(gestureForBTByAccountDetail)
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

    var content: String {
        get {
            return bbCodeView.text
        }
        set {
            bbCodeView.text = newValue
        }
    }
    
    var bbCodeView: BBCodeView {
        get {
            return (contentView as! StatusContentContainerView).bbCodeView
        }
    }
    
    var btByIconImage: UIImage? {
        get {
            return btByImageView.image
        }
        set {
            btByImageView.image = newValue
        }
    }

    @IBAction func replyAction(_ sender: Any) {
        NSLog("Reply is not implemented yet!")
    }

    @IBAction func btAction(_ sender: Any) {
        _performStatusAction(
                button: btButton,
                doAction: .reblog,
                undoAction: .unreblog,
                isSelected: {$0.reblogged})
    }

    @IBAction func favAction(_ sender: Any) {
        _performStatusAction(
                button: favButton,
                doAction: .favourite,
                undoAction: .unfavourite,
                isSelected: {$0.favourited})
    }

    func resumeBBCodeAnimations() {
        bbCodeView.resumeLayerAnimations()
    }

    private func _performStatusAction(
            button: UIButton,
            doAction: StatusAction,
            undoAction: StatusAction,
            isSelected: @escaping (Status) -> Bool?
    ) {
        let isSelectedPrevious = button.isSelected
        button.isSelected = !isSelectedPrevious

        let action: StatusAction
        if isSelectedPrevious {
            action = undoAction
        }
        else {
            action = doAction
        }

        ClientManager.shared.performStatusAction(
                statusId: _status.id,
                action: action
        ).then(in: .main) {
            switch $0 {
            case .success(let s, _):
                button.isSelected = isSelected(s) ?? isSelectedPrevious
            default:
                button.isSelected = isSelectedPrevious
            }
        }
    }

    @objc private func _statusDetailAction(sender: Any) {
        Notifications.showStatusDetail.post(
                statusDetail: StatusDetailParams(status: _status)
        )
    }

    @objc private func _accountDetailAction(sender: Any) {
        let account = _status.account

        Notifications.showAccountDetail.post(
                accountDetail: AccountDetailParams(account: account)
        )
    }

    @objc private func _btAccountDetailAction(sender: Any) {
        guard let account = _status.reblog?.account else {
            return
        }

        Notifications.showAccountDetail.post(
                accountDetail: AccountDetailParams(account: account)
        )
    }
}
