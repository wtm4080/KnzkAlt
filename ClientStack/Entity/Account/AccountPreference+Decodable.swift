//
// Created by mopopo on 2018/07/09.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension AccountPreference: Decodable {
    private enum CodingKeys: String, CodingKey {
        case defaultPostingVisibility = "privacy"
        case isSensitive = "sensitive"
        case note
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        defaultPostingVisibility = try values.decode(StatusEntityVisibility.self, forKey: .defaultPostingVisibility)
        isSensitive = try values.decode(Bool.self, forKey: .isSensitive)
        note = try values.decode(String.self, forKey: .note)
    }
}
