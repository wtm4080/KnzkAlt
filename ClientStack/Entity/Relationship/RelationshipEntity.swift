//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Account relationship entity
struct RelationshipEntity {
    /// Target account ID
    let targetAccountID: String

    /// Whether the user is currently following the account
    let isFollowing: Bool

    /// Whether the user is currently being followed by the account
    let isFollowedBy: Bool

    /// Whether the user is currently blocking the account
    let isBlocking: Bool

    /// Whether the user is currently muting the account
    let isMuting: Bool

    /// Whether the user is also muting notifications
    let isMutingNotifications: Bool

    /// Whether the user has requested to follow the account
    let isFollowRequested: Bool

    /// Whether the user is currently blocking the account's domain
    let isDomainBlocking: Bool
}
