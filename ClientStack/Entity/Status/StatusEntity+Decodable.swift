//
// Created by mopopo on 2018/07/19.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension StatusEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case fediverseURI = "uri"
        case statusPageURL = "url"
        case postedAccount = "account"
        case inReplyToStatusID = "in_reply_to_id"
        case inReplyToAccountID = "in_reply_to_account_id"
        case contentHTML = "content"
        case createdAt = "created_at"
        case emojis
        case reblogsCount = "reblogs_count"
        case favoritesCount = "favourites_count"
        case isReblogged = "reblogged"
        case isFavourited = "favourited"
        case isMuted = "muted"
        case isContainingSensitiveAttachments = "sensitive"
        case spoilerText = "spoiler_text"
        case visibility
        case mediaAttachments = "media_attachments"
        case mentions
        case tags
        case postedApp = "application"
        case detectedLanguage = "language"
        case isPinned = "pinned"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        fediverseURI = try values.decode(URL.self, forKey: .fediverseURI)
        statusPageURL = try values.decode(URL.self, forKey: .statusPageURL)
        postedAccount = try values.decode(AccountEntityCompound.self, forKey: .postedAccount)
        inReplyToStatusID = try values.decodeIfPresent(String.self, forKey: .inReplyToStatusID)
        inReplyToAccountID = try values.decodeIfPresent(String.self, forKey: .inReplyToAccountID)
        contentHTML = try values.decode(String.self, forKey: .contentHTML)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        emojis = try values.decode(Array<EmojiEntity>.self, forKey: .emojis)
        reblogsCount = try values.decode(UInt.self, forKey: .reblogsCount)
        favoritesCount = try values.decode(UInt.self, forKey: .favoritesCount)
        isReblogged = try values.decodeIfPresent(Bool.self, forKey: .isReblogged)
        isFavourited = try values.decodeIfPresent(Bool.self, forKey: .isFavourited)
        isMuted = try values.decodeIfPresent(Bool.self, forKey: .isMuted)
        isContainingSensitiveAttachments = try values.decode(Bool.self, forKey: .isContainingSensitiveAttachments)
        spoilerText = try values.decode(String.self, forKey: .spoilerText)
        visibility = try values.decode(StatusEntityVisibility.self, forKey: .visibility)
        mediaAttachments = try values.decode(Array<AttachmentEntity>.self, forKey: .mediaAttachments)
        mentions = try values.decode(Array<MentionEntity>.self, forKey: .mentions)
        tags = try values.decode(Array<TagEntity>.self, forKey: .tags)
        postedApp = try values.decodeIfPresent(ApplicationEntity.self, forKey: .postedApp)
        detectedLanguage = try values.decodeIfPresent(String.self, forKey: .detectedLanguage)
        isPinned = try values.decodeIfPresent(Bool.self, forKey: .isPinned)
    }
}
