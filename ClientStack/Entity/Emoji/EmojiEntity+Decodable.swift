//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension EmojiEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case shortcode
        case staticImageURL = "static_url"
        case imageURL = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        shortcode = try values.decode(String.self, forKey: .shortcode)
        staticImageURL = try values.decode(URL.self, forKey: .staticImageURL)
        imageURL = try values.decode(URL.self, forKey: .imageURL)
    }
}
