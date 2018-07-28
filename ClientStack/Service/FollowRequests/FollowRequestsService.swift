//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum FollowRequestsService {
    /// Fetching a list of follow requests
    /// Returns an array of Account entities which have requested to follow the authenticated user.
    case followRequests(param: ServiceParam, query: RangeQuery)

    /// Authorizing follow requests
    /// Returns an empty object.
    case authorise(param: ServiceParam, accountID: String)

    /// Rejecting follow requests
    /// Returns an empty object.
    case reject(param: ServiceParam, accountID: String)
}
