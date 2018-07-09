//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct ResultsEntity: Codable {
    let accounts: [AccountCompoundEntity]
    let statuses: [StatusCompoundEntity]
    let hashtags: [String]
}
