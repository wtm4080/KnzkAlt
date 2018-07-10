//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Mention entity
struct MentionEntity {
    /// URL of user's profile (can be remote)
    let userProfileURL: URL

    /// The username of the account
    let userName: String

    /// Equals `username` for local users, includes `@domain` for remote ones
    let userNameWithDomain: String

    /// Account ID
    let accountID: String
}
