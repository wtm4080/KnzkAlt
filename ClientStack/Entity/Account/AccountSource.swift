//
// Created by mopopo on 2018/07/09.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Extra account attributes
struct AccountSource: Codable {
    /// Selected preference: Default privacy of new toots
    let privacy: StatusEntityVisibility

    /// Selected preference: Mark media as sensitive by default?
    let sensitive: Bool

    /// Plain-text version of the account's `note`
    let note: String
}
