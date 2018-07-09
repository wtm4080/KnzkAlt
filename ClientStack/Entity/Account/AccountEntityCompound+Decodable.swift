//
// Created by mopopo on 2018/07/09.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension AccountEntityCompound: Decodable {
    private enum CodingKeys: String, CodingKey {
        case moved = "moved"
    }

    init(from decoder: Decoder) throws {
        original = try AccountEntity(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)

        moved = try values.decodeIfPresent(AccountEntity.self, forKey: .moved)
    }
}
