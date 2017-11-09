//
//  MainVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/11/09.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class MainVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.performSegue(withIdentifier: "Initial", sender: self)
    }
}
