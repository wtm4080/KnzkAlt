//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension CardEntityOEmbedData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case providerName = "provider_name"
        case providerURL = "provider_url"
        case html
        case width
        case height
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        authorName = try values.decodeIfPresent(String.self, forKey: .authorName)
        authorURL = try values.decodeIfPresent(URL.self, forKey: .authorURL)
        providerName = try values.decodeIfPresent(String.self, forKey: .providerName)
        providerURL = try values.decodeIfPresent(URL.self, forKey: .providerURL)
        html = try values.decodeIfPresent(String.self, forKey: .html)
        width = try values.decodeIfPresent(UInt.self, forKey: .width)
        height = try values.decodeIfPresent(UInt.self, forKey: .height)
    }
}
