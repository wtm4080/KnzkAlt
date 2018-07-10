//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension MentionEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case userProfileURL = "url"
        case userName = "username"
        case userNameWithDomain = "acct"
        case accountID = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        userProfileURL = try values.decode(URL.self, forKey: .userProfileURL)
        userName = try values.decode(String.self, forKey: .userName)
        userNameWithDomain = try values.decode(String.self, forKey: .userNameWithDomain)
        accountID = try values.decode(String.self, forKey: .accountID)
    }
}
