//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct NotificationEntity: Codable {
    let id: String
    let type: NotificationEntityType
    let createdAt: Date
    let account: AccountEntityCompound
    let status: StatusCompoundEntity?
}

enum NotificationEntityType: Codable {
    init(from decoder: Decoder) throws {
        fatalError("Not implemented yet.")
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("Not implemented yet.")
    }
    
    case mention
    case reblog
    case favorite
    case follow
}
