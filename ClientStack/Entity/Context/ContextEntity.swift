//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Toot(status) context entity
struct ContextEntity {
    /// The ancestors of the status in the conversation, as a list of Statuses
    let ancestors: [StatusEntity]

    /// The descendants of the status in the conversation, as a list of Statuses
    let descenders: [StatusEntity]
}
