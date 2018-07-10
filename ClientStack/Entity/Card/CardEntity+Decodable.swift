//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension CardEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case url
        case title
        case description
        case imageURL = "image"
        case type
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        url = try values.decode(URL.self, forKey: .url)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        imageURL = try values.decodeIfPresent(URL.self, forKey: .imageURL)
        type = try values.decode(CardEntityType.self, forKey: .type)
        oEmbedData = try CardEntityOEmbedData(from: decoder)
    }
}
