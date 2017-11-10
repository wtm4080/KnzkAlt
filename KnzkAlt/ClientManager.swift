//
// Created by mopopo on 2017/11/10.
// Copyright (c) 2017 AtCurio. All rights reserved.
//

import Foundation
import MastodonKit
import Hydra

class ClientManager {
    static let shared = ClientManager()
    private init() {}

    private var _standard: Client {
        return Client(
                baseURL: "https://knzk.me",
                accessToken: Keychain.shared.accessToken)
    }

    // for CDN configuration
    private var _media: Client {
        return _standard
    }

    func homeTL() -> Promise<Result<[Status]>> {
        let request = Timelines.home()

        return Promise<Result<[Status]>>(in: .background) {
            [unowned self] resolve, _, _ in

            self._standard.run(request) {
                statuses in

                resolve(statuses)
            }
        }
    }
}
