//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Filter entity
///
/// If `whole_word` is true, client app should do:
///
/// * Defile 'Word constituent character' for your app.
///   In official implementation, it's [A-Za-z0-9_] for JavaScript, it's [[:word:]] for Ruby.
///   In Ruby case it's POSIX character class (Letter | Mark | Decimal_Number | Connector_Punctuation).
/// * If the phrase starts with word character, and if the previous character before matched range is word character,
///   its matched range should treat to not match.
/// * If the phrase ends with word character, and if the next character after matched range is word character,
///   its matched range should treat to not match.
///
/// Please check `app/javascript/mastodon/selectors/index.js` and `app/lib/feed_manager.rb` for more details.
/// Most case client apps are compared to WebUI(JS), they should obey to JS implementation.
struct FilterEntity: Decodable {
    /// ID of the filter
    let id: String

    /// Keyword or phrase
    let phrase: String

    /// Array of strings that indicate filter context.
    /// Each string is one of `home`, `notifications`, `public`, `thread`.
    let context: [FilterContext]

    /// String such as "2018-07-06T00:59:13:161Z" that indicates when this filter is expired.
    let expiresAt: Date?

    /// Boolean that indicates irreversible server side filtering.
    let isIrreversible: Bool

    /// Boolean that indicates word match.
    let isWholeWord: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case phrase
        case context
        case expiresAt = "expires_at"
        case isIrreversible = "irreversible"
        case isWholeWord = "whole_word"
    }
}
