//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct CardEntity: Decodable {
    let url: URL
    let title: String
    let description: String
    let image: URL?
    let type: CardEntityType
    let oEmbedData: CardEntityOEmbedData?
}

enum CardEntityType: String, Decodable {
    case link
    case photo
    case video
    case rich
}

struct CardEntityOEmbedData: Decodable {
    let authorName: String
    let authorURL: URL
    let providerName: String
    let providerURL: URL
    let html: String
    let width: UInt
    let height: UInt
}
