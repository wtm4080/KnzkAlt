//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension ResultsEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case accounts
        case statuses
        case hashtags
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        accounts = try values.decode(Array<AccountEntityCompound>.self, forKey: .accounts)
        statuses = try values.decode(Array<StatusEntityCompound>.self, forKey: .statuses)
        hashtags = try values.decode(Array<String>.self, forKey: .hashtags)
    }
}
