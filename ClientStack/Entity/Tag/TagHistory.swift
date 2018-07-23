//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct TagHistory: Decodable {
    /// The day in UNIX timestamp
    let day: UInt

    /// Total statuses using that hash tag during that day
    let uses: UInt

    /// Total unique accounts using that hash tag during that day
    let accounts: UInt
}
