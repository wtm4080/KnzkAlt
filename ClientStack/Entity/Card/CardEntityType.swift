//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// The card entity type that respects OEmbed type
/// https://oembed.com
enum CardEntityType: String, Decodable {
    /// Responses of this type allow a provider to return any generic embed data
    /// (such as `title` and `author_name`), without providing either the URL or HTML parameters.
    /// The consumer may then link to the resource, using the URL specified in the original request.
    case link

    /// This type is used for representing static photos.
    case photo

    /// This type is used for representing playable videos.
    case video

    /// This type is used for rich HTML content that does not fall under one of the other categories.
    case rich
}
