//
// Created by mopopo on 2017/11/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import MastodonKit

struct ClientManager {
    static let shared = ClientManager()
    private init() {}

    private let _standardHost = "https://knzk.me"

    var standard: Client {
        return Client(baseURL: _standardHost, accessToken: Keychain.shared.accessToken)
    }

    // for CDN configuration
    var media: Client {
        return standard
    }
}
