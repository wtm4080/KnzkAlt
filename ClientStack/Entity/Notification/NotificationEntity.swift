//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Mastodon notification entity
struct NotificationEntity {
    /// The notification ID
    let id: String

    /// One of `mention`, `reblog`, `favourite`, `follow`
    let type: NotificationEntityType

    /// The time the notification was created
    let createdAt: Date

    /// The Account sending the notification to the user
    let senderAccount: AccountEntityCompound

    /// The Status associated with the notification, if applicable
    let associatedStatus: StatusCompoundEntity?
}
