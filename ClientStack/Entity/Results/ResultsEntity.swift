//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Search (or some other operations) results entity
struct ResultsEntity {
    /// An array of matched Accounts
    let accounts: [AccountEntityCompound]

    /// An array of matched Statuses
    let statuses: [StatusCompoundEntity]

    /// An array of matched hashtags, as strings
    let hashtags: [String]
}
