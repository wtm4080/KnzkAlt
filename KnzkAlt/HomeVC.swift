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

        let client = Client(
                baseURL: "https://knzk.me",
                accessToken: Keychain.shared.accessToken)
        let request = Timelines.home()
        client.run(request) {
            statuses in

            NSLog("Statuses: \(String(describing: statuses))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

