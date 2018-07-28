//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum FiltersService {
    /// Fetching a list of filters
    /// Returns an array of Filter entities.
    case filters(param: ServiceParam)

    /// Get a filter
    /// Returns a Filter entity.
    case filter(param: ServiceParam, id: String)

    /// Creating a filter
    /// Returns a Filter entity.
    case create(param: ServiceParam, form: FilterCreateForm)

    /// Update a filter
    /// Returns a Filter entity.
    /// Note: Currently there is noway to remove expires from existing filter.
    case update(param: ServiceParam, id: String, form: FilterCreateForm)

    /// Delete a filter
    /// Returns an empty object.
    case delete(param: ServiceParam, id: String)
}
