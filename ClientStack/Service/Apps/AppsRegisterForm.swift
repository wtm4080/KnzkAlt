//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct AppsRegisterForm {
    /// Name of your application
    let clientName: String

    /// Where the user should be redirected after authorization
    /// (for no redirect, use `urn:ietf:wg:oauth:2.0:oob`)
    let redirectURIs: String

    /// This can be a space-separated list of the following items: `read`, `write`, `follow`
    /// (see [this page](https://github.com/tootsuite/documentation/blob/master/Using-the-API/OAuth-details.md)
    /// for details on what the scopes do)
    let scopes: [AppsRegisterScope]

    /// URL to the homepage of your app
    let websiteURL: URL?

    func toParams() -> [String: Any] {
        var params: [String: Any] = [
            "client_name": clientName,
            "redirect_uris": redirectURIs,
            "scopes": scopes.reduce(into: "", { (result, scope) in
                if result.isEmpty {
                    result.append(scope.rawValue)
                } else {
                    result.append(" \(scope.rawValue)")
                }
            })
        ]

        if let wURL = websiteURL {
            params["website"] = wURL.absoluteString
        }

        return params
    }
}
