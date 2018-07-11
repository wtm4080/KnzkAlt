//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension PushSubscriptionEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case endpointURL = "endpoint"
        case serverKey = "server_key"
        case alerts
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        endpointURL = try values.decode(URL.self, forKey: .endpointURL)
        serverKey = try values.decode(String.self, forKey: .serverKey)
        alerts = try values.decodeIfPresent(Dictionary<String, String>.self, forKey: .alerts)
    }
}
