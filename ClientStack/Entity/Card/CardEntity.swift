//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Account card entity
struct CardEntity {
    /// The URL associated with the card
    let url: URL

    /// The title of the card
    let title: String

    /// The card description
    let description: String

    /// The image associated with the card, if any
    let imageURL: URL?

    /// `link`, `photo`, `video`, or `rich`, that respects OEmbed type
    let type: CardEntityType

    /// OEmbed data
    let oEmbedData: CardEntityOEmbedData
}
