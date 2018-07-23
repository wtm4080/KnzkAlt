//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum StatusEntityVisibility: String, Decodable {
    case `public`
    case unlisted
    case `private`
    case direct
}
