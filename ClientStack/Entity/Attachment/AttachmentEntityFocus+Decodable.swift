//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension AttachmentEntityFocus: Decodable {
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        x = try values.decode(Double.self, forKey: .x)
        y = try values.decode(Double.self, forKey: .y)
    }
}
