//
// Created by mopopo on 2018/07/09.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Compounded Mastodon account entity that contains some account entities and other data
struct AccountEntityCompound {
    /// Mastodon account entity itself
    let original: AccountEntity

    /// If the owner decided to switch accounts, new account is in this attribute
    let moved: AccountEntity?
}
