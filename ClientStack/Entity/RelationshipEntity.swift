//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct RelationshipEntity: Codable {
    let id: String
    let following: Bool
    let followedBy: Bool
    let blocking: Bool
    let muting: Bool
    let mutingNotifications: Bool
    let requested: Bool
    let domainBlocking: Bool
}
