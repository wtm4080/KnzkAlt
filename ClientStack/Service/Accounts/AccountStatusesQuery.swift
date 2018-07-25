//
// Created by mopopo on 2018/07/25.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct AccountStatusesQuery {
    /// Only return statuses that have media attachments
    let isOnlyMedia: Bool?

    /// Only return statuses that have been pinned
    let isOnlyPinned: Bool?

    /// Skip statuses that reply to other statuses
    let isExcludeReplies: Bool?

    /// Statuses range
    let range: RangeQuery

    func toParameters() -> [String: Any] {
        var ps = range.toParameters()

        if let iOM = isOnlyMedia {
            ps["only_media"] = iOM
        }

        if let iOP = isOnlyPinned {
            ps["pinned"] = iOP
        }

        if let iER = isExcludeReplies {
            ps["limit"] = iER
        }

        return ps
    }
}
