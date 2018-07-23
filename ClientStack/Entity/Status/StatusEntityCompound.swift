//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Compounded status entity with reblogged status
struct StatusEntityCompound {
    /// Original status
    let status: StatusEntity

    /// `null` or the reblogged Status
    let reblog: StatusEntity?
}
