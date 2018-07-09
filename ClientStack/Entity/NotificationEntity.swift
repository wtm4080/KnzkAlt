//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct NotificationEntity: Decodable {
    let id: String
    let type: NotificationEntityType
    let createdAt: Date
    let account: AccountEntityCompound
    let status: StatusCompoundEntity?
}

enum NotificationEntityType: Decodable {
    init(from decoder: Decoder) throws {
        fatalError("Not implemented yet.")
    }

    case mention
    case reblog
    case favorite
    case follow
}
