//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Tag entity
struct TagEntity: Decodable {
    /// The hash tag, not including the preceding `#`
    let name: String

    /// The URL of the hash tag
    let url: URL

    /// Array of daily usage history. Not included in statuses. Last 7 days.
    let history: [TagHistory]?
}
