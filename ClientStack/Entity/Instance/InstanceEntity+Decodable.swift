//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension InstanceEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case uri
        case title
        case description
        case email
        case version
        case streamingAPIURLs = "urls"
        case languageCodes = "languages"
        case contactAccount = "contact_account"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        uri = try values.decode(URL.self, forKey: .uri)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        email = try values.decode(String.self, forKey: .email)
        version = try values.decode(String.self, forKey: .version)
        streamingAPIURLs = try values.decode(Array<URL>.self, forKey: .streamingAPIURLs)
        languageCodes = try values.decode(Array<String>.self, forKey: .languageCodes)
        contactAccount = try values.decode(AccountEntityCompound.self, forKey: .contactAccount)
    }
}
