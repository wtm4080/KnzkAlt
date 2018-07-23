//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum ServiceHost {
    case local
    case other(isSecure: Bool, host: String)

    var url: URL? {
        switch self {
            case .local:
                return URL(string: "http://localhost:3000")
            case .other(let isSecure, let host):
                return URL(string: "http\(isSecure ? "s" : "")://\(host)")
        }
    }
}
