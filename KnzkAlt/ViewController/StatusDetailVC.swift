//
//  StatusDetailVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/12/23.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit

struct StatusDetailParams {
    let status: Status
}

class StatusDetailVC: UIViewController {
    let params: StatusDetailParams

    init(params: StatusDetailParams) {
        self.params = params

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("StatusDetailVC does not support init?(coder:).")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
