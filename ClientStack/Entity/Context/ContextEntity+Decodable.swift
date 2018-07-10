//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension ContextEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case ancestors
        case descenders
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        ancestors = try values.decode(Array<StatusEntity>.self, forKey: .ancestors)
        descenders = try values.decode(Array<StatusEntity>.self, forKey: .descenders)
    }
}
