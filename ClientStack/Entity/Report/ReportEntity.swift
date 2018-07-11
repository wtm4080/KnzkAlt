//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Report entity
struct ReportEntity {
    /// The ID of the report
    let id: String

    /// The action taken in response to the report by admin or moderator
    let isActionTaken: Bool
}
