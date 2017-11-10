//
//  FirstViewController.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit
import MastodonKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = Timelines.home()
        ClientManager.shared.standard.run(request) {
            statuses in

            NSLog("Statuses: \(String(describing: statuses))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

