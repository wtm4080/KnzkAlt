//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct StatusEntity: Codable {
    let id: String
    let uri: URL
    let url: URL
    let account: AccountEntityCompound
    let inReplyToID: String?
    let inReplyToAccountID: String?
    let content: String
    let createdAt: Date
    let emojis: [EmojiEntity]
    let reblogsCount: UInt
    let favoritesCount: UInt
    let reblogged: Bool?
    let favorited: Bool?
    let muted: Bool?
    let sensitive: Bool
    let spoilerText: String
    let visibility: StatusEntityVisibility
    let mediaAttachments: [AttachmentEntity]
    let mentions: [MentionEntity]
    let tags: [TagEntity]
    let application: ApplicationEntity?
    let language: String?
    let pinned: Bool?
}

struct StatusCompoundEntity: Codable {
    let status: StatusEntity
    let reblog: StatusEntity?
}

enum StatusEntityVisibility: String, Codable {
    case `public`
    case unlisted
    case `private`
    case direct
}
