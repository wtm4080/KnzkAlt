//
//  MainVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/11/09.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class MainVC: UITabBarController, ANAccessTokenRefreshed, ANLogoutPerformed {
    override func viewDidLoad() {
        super.viewDidLoad()

        AppNotification.shared.observer.register(observer: self as ANAccessTokenRefreshed)
        AppNotification.shared.observer.register(observer: self as ANLogoutPerformed)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Keychain.shared.accessToken == nil {
            _presentInitialVC()
        }
    }

    func observeAccessTokenRefreshed() {
        if let at = Keychain.shared.accessToken, !at.isEmpty {
            let alert = UIAlertController(
                    title: "Login",
                    message: "Login succeeded!",
                    preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(
                    title: "Login Error",
                    message: "Something wrong in login sequence!",
                    preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }

        self.selectedIndex = 0
    }

    func observeLogoutPerformed() {
        _presentInitialVC()

        self.selectedIndex = 0
    }

    private func _presentInitialVC() {
        self.performSegue(withIdentifier: "Initial", sender: self)
    }
}
