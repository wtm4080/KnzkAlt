//
// Created by mopopo on 2017/11/09.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import KeychainAccess

struct Keychain {
    static let shared = Keychain()

    private let _kc = KeychainAccess.Keychain(service: "me.knzk.knzk-alt")

    private init() {}

    private let _accessTokenKey = "access_token"
    var accessToken: String? {
        get {
            return _kc[_accessTokenKey]
        }
        set {
            _kc[_accessTokenKey] = newValue
        }
    }
}
