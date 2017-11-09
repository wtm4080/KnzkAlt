//
//  MenuVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    @IBAction func logoutAction(_ sender: Any) {
        var kc = Keychain.shared
        kc.accessToken = nil

        Notifications.LogoutPerformed.post()
    }
}
