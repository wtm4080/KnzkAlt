//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Emoji in toot entity
struct EmojiEntity {
    /// The shortcode of the emoji
    let shortcode: String

    /// URL to the emoji static image
    let staticImageURL: URL

    /// URL to the emoji image
    let imageURL: URL
}
