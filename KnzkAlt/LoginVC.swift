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
    
    @IBOutlet weak var _progressView: UIProgressView!
    
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
        view.addSubview(webView)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        view.bringSubview(toFront: _progressView)
        _progressView.isHidden = true
        _progressView.progress = 0.0
    }

    deinit {
        _webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        _webView?.removeObserver(self, forKeyPath: "loading")
    }

    override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            _progressView.setProgress(Float(self._webView?.estimatedProgress ?? 0.0), animated: true)
        }
        else if keyPath == "loading" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = _webView?.isLoading ?? false

            if _webView?.isLoading ?? false {
                _progressView.setProgress(0.1, animated: true)

                _progressView.isHidden = false
                _progressView.alpha = 0.0

                UIView.animate(
                        withDuration: 0.5,
                        animations: { [weak self] in self?._progressView.alpha = 1.0 },
                        completion: { finish in  })
            }
            else {
                self._progressView.setProgress(0.0, animated: false)

                UIView.animate(
                        withDuration: 0.5,
                        animations: { [weak self] in self?._progressView.alpha = 0.0 },
                        completion: { finish in  })
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
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
