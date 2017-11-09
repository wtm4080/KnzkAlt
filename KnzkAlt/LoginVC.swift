//
//  LoginVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit
import WebKit

class LoginVC: UIViewController, WKNavigationDelegate {
    private var _webView: WKWebView?

    private var _loginResult: LoginResult?

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(
                frame: CGRect(
                        x: 0,
                        y: 0,
                        width:
                        self.view.frame.size.width,
                        height: self.view.frame.size.height))
        _webView = webView

        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)

        let safeArea = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Login.login().then(in: .main) {
            [weak self] result in

            switch result {
                case .success(let result):
                    self?._loginResult = result

                    guard let authURL = result.authURL() else {
                        return
                    }

                    self?._webView?.load(URLRequest(url: authURL))
                default:
                    return
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let loginResult = _loginResult else {
            return
        }

        guard let webViewURL = _webView?.url else {
            return
        }

        LoginAuth.auth(url: webViewURL, loginResult: loginResult).then(in: .background) {
            result in

            switch result {
                case .success(let token):
                    LoginVerifyCred.verify(authResult: token).then(in: .main) {
                        verifyResult in

                        switch verifyResult {
                            case .success(let account):
                                NSLog("User ID: \(account.userId), User name: \(account.userName)")
                            default:
                                return
                        }
                    }
                default:
                    return
            }
        }
    }
}
