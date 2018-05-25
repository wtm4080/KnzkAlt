//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct NotificationEntity {
    let id: String
    let type: NotificationEntityType
    let createdAt: Date
    let account: AccountCompoundEntity
    let status: StatusCompoundEntity?
}

enum NotificationEntityType {
    case mention
    case reblog
    case favorite
    case follow
}
