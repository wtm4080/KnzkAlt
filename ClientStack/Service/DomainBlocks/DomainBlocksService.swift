//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum DomainBlocksService {
    /// Fetching a user's blocked domains
    /// Returns an array of strings.
    case domainBlocks(param: ServiceParam, query: RangeQuery)

    /// Blocking a domain
    /// Returns an empty object.
    case block(param: ServiceParam, domain: String)

    /// Unblocking a domain
    /// Returns an empty object.
    case unblock(param: ServiceParam, domain: String)
}
