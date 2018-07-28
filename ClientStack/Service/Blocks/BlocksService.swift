//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum BlocksService {
    /// Fetching a user's blocks
    /// Returns an array of Account entities blocked by the authenticated user.
    case blocks(param: ServiceParam, query: RangeQuery)
}
