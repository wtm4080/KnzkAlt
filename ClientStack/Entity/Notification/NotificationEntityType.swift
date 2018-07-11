//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Notification entity type
enum NotificationEntityType: String, Decodable {
    case mention
    case reblog
    case favorite
    case follow
}
