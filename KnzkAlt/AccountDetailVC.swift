//
//  AccountDetailVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/12/23.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit

struct AccountDetailParams {
    let account: Account
}

class AccountDetailVC: UIViewController {
    let params: AccountDetailParams

    init(params: AccountDetailParams) {
        self.params = params

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("AccountDetailVC does not support init?(coder:).")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
