//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct AccountEntity: Codable {
    let id: String
    let username: String
    let acct: String
    let displayName: String
    let locked: Bool
    let createdAt: Date
    let followersCount: UInt
    let followingCount: UInt
    let statusesCount: UInt
    let note: String
    let url: URL
    let avatar: URL
    let avatarStatic: URL
    let header: URL
    let headerStatic: URL

    var usernameWithDomain: String {
        return acct
    }
}

struct AccountCompoundEntity: Codable {
    let original: AccountEntity
    let moved: AccountEntity?

    // source value is present when accessing GET /api/v1/accounts/verify_credentials
    let source: AccountSource?
}

struct AccountSource: Codable {
    let privacy: StatusEntityVisibility
    let sensitive: Bool
    let note: String
}
