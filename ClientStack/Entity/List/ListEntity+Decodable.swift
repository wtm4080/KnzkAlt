//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension ListEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
    }
}
