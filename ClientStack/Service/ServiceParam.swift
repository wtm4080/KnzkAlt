//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct ServiceParam {
    let host: ServiceHost
    let accessToken: String

    var headers: [String: String] {
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
