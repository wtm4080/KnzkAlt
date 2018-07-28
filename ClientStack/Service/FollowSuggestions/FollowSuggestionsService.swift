//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum FollowSuggestionsService {
    /// Fetching a list of follow suggestions
    /// Returns an array of Account entities which is suggested.
    case suggestions(param: ServiceParam)

    /// Delete a user from follow suggestions
    /// Returns an empty object.
    case delete(param: ServiceParam, accountID: String)
}
