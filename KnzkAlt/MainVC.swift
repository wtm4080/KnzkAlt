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

        Notifications.accessTokenRefreshed.register(
                observer: self,
                selector: #selector(type(of: self)._observeAccessTokenRefreshed(n:))
        )
        Notifications.logoutPerformed.register(
                observer: self,
                selector: #selector(type(of: self)._observeLogoutPerformed(n:))
        )
    }

    deinit {
        Notifications.unregisterAll(observer: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Keychain.shared.accessToken == nil {
            _presentInitialVC()
        }
    }

    @objc private func _observeAccessTokenRefreshed(n: Notification) {
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

    @objc private func _observeLogoutPerformed(n: Notification) {
        _presentInitialVC()
    }

    private func _presentInitialVC() {
        self.performSegue(withIdentifier: "Initial", sender: self)
    }
}
