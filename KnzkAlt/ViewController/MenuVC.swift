//
//  MenuVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {
    @IBAction func logoutAction(_ sender: Any) {
        ClientManager.shared.logout()
    }
}
