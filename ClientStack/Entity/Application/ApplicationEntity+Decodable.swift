//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension ApplicationEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case websiteURL = "website"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        websiteURL = try values.decodeIfPresent(URL.self, forKey: .websiteURL)
    }
}
