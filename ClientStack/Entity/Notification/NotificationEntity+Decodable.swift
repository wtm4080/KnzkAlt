//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension NotificationEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case createdAt = "created_at"
        case senderAccount = "account"
        case associatedStatus = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        type = try values.decode(NotificationEntityType.self, forKey: .type)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        senderAccount = try values.decode(AccountEntityCompound.self, forKey: .senderAccount)
        associatedStatus = try values.decodeIfPresent(StatusEntityCompound.self, forKey: .associatedStatus)
    }
}
