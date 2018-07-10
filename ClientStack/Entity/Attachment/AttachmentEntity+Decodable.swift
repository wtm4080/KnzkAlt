//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension AttachmentEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case localImageURL = "url"
        case remoteImageURL = "remote_url"
        case previewImageURL = "preview_url"
        case urlText = "text_url"
        case metadata = "meta"
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        type = try values.decode(AttachmentEntityType.self, forKey: .type)
        localImageURL = try values.decodeIfPresent(URL.self, forKey: .localImageURL)
        remoteImageURL = try values.decodeIfPresent(URL.self, forKey: .remoteImageURL)
        previewImageURL = try values.decodeIfPresent(URL.self, forKey: .previewImageURL)
        urlText = try values.decodeIfPresent(String.self, forKey: .urlText)
        metadata = try values.decodeIfPresent(AttachmentEntityMeta.self, forKey: .metadata)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
