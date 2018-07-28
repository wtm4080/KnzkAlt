//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum FavouritesService {
    /// Fetching a user's favourites
    /// Returns an array of Status entities favourited by the authenticated user.
    case favourites(param: ServiceParam, query: RangeQuery)
}
