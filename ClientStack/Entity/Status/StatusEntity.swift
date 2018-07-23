//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Status entity
struct StatusEntity {
    /// The ID of the status
    let id: String

    /// A Fediverse-unique resource ID
    let fediverseURI: URL

    /// URL to the status page (can be remote)
    let statusPageURL: URL
    
    /// The Account which posted the status
    let postedAccount: AccountEntityCompound

    /// `null` (if the status that is replied to is unknown) or the ID of the status it replies to
    let inReplyToStatusID: String?

    /// `null` (if the status that is replied to is unknown) or the ID of the account it replies to
    let inReplyToAccountID: String?

    /// Body of the status; this will contain HTML (remote HTML already sanitized)
    let contentHTML: String

    /// The time the status was created
    let createdAt: Date

    /// An array of Emoji
    let emojis: [EmojiEntity]

    /// The number of reblogs for the status
    let reblogsCount: UInt

    /// The number of favourites for the status
    let favoritesCount: UInt

    /// Whether the authenticated user has reblogged the status
    let isReblogged: Bool?

    /// Whether the authenticated user has favourited the status
    let isFavourited: Bool?

    /// Whether the authenticated user has muted the conversation this status from
    let isMuted: Bool?

    /// Whether media attachments should be hidden by default
    let isContainingSensitiveAttachments: Bool

    /// If not empty, warning text that should be displayed before the actual content
    /// When `spoilerText` present, `isContainingSensitiveAttachments` is true
    let spoilerText: String

    /// One of `public`, `unlisted`, `private`, `direct`
    let visibility: StatusEntityVisibility

    /// An array of Attachments
    let mediaAttachments: [AttachmentEntity]

    /// An array of Mentions
    let mentions: [MentionEntity]

    /// An array of Tags
    let tags: [TagEntity]

    /// Application from which the status was posted
    let postedApp: ApplicationEntity?

    /// The detected language for the status, if detected
    let detectedLanguage: String?

    /// Whether this is the pinned status for the account that posted it
    let isPinned: Bool?
}
