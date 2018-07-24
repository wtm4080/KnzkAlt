//
// Created by mopopo on 2018/07/24.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Query representation when getting items from the APIs
/// Note: `max_id` and `since_id` for next and previous pages are provided in the `Link` header.
///       It is *not* possible to use the `id` of the returned objects to construct your own URLs,
///       because the results are sorted by an internal key.
struct RangeQuery {
    /// Get a list of items with ID less than this value
    let maxID: String?

    /// Get a list of items with ID greater than this value
    let sinceID: String?

    /// Maximum number of followers to get (Default 40, Max 80)
    let limit: UInt?

    func toParameters() -> [String: Any] {
        var ps = [String: Any]()

        if let mID = maxID {
            ps["max_id"] = mID
        }

        if let sID = sinceID {
            ps["since_id"] = sID
        }

        if let l = limit {
            ps["limit"] = min(l, 80)
        }

        return ps
    }
}
