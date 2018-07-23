//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension StatusEntityCompound: Decodable {
    private enum CodingKeys: String, CodingKey {
        case reblog
    }

    init(from decoder: Decoder) throws {
        status = try StatusEntity(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)

        reblog = try values.decodeIfPresent(StatusEntity.self, forKey: .reblog)
    }
}
