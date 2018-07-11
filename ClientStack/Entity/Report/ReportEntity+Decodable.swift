//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension ReportEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case isActionTaken = "action_taken"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        isActionTaken = try values.decode(Bool.self, forKey: .isActionTaken)
    }
}
