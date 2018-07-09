//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Mastodon account entity
struct AccountEntity: Codable {
    /// The ID of account
    let id: String

    /// The username of the account
    let username: String

    /// Equals `username` for local users, includes `@domain` for remote ones
    let acct: String

    /// The account's display name
    let displayName: String

    /// Boolean for when the account cannot be followed without waiting for approval first
    let locked: Bool

    /// The time the account was created
    let createdAt: Date

    /// The number of followers for the account
    let followersCount: UInt

    /// The number of accounts the given account is followed
    let followingCount: UInt

    /// The number of statuses the account has made
    let statusesCount: UInt

    /// Biography of user
    let note: String

    /// URL of the user's profile page (can be remote)
    let url: URL

    /// URL to the avatar image
    let avatar: URL

    /// URL to the avatar static image (gif)
    let avatarStatic: URL

    /// URL to the header image
    let header: URL

    /// URL to the header static image (gif)
    let headerStatic: URL

    /// `source` value is present when accessing GET /api/v1/accounts/verify_credentials
    let source: AccountSource?

    /// Array of profile metadata field, each element has `name` and `value`
    let fields: [String: String]?

    /// Boolean to indicate that the account performs automated actions
    let bot: Bool?
}
