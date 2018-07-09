//
// Created by mopopo on 2018/07/09.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension AccountEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case userNameWithDomain = "acct"
        case displayName = "display_name"
        case isLocked = "locked"
        case createdAt = "created_at"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case statusesCount = "statuses_count"
        case note = "note"
        case profilePageURL = "url"
        case avatarImageURL = "avatar"
        case avatarStaticImageURL = "avatar_static"
        case headerImageURL = "header"
        case headerStaticImageURL = "header_static"
        case preference = "source"
        case profileMetadata = "fields"
        case isBot = "bot"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        userName = try values.decode(String.self, forKey: .userName)
        userNameWithDomain = try values.decode(String.self, forKey: .userNameWithDomain)
        displayName = try values.decode(String.self, forKey: .displayName)
        isLocked = try values.decode(Bool.self, forKey: .isLocked)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        followersCount = try values.decode(UInt.self, forKey: .followersCount)
        followingCount = try values.decode(UInt.self, forKey: .followingCount)
        statusesCount = try values.decode(UInt.self, forKey: .statusesCount)
        note = try values.decode(String.self, forKey: .note)
        profilePageURL = try values.decode(URL.self, forKey: .profilePageURL)
        avatarImageURL = try values.decode(URL.self, forKey: .avatarImageURL)
        avatarStaticImageURL = try values.decode(URL.self, forKey: .avatarStaticImageURL)
        headerImageURL = try values.decode(URL.self, forKey: .headerImageURL)
        headerStaticImageURL = try values.decode(URL.self, forKey: .headerStaticImageURL)
        preference = try values.decodeIfPresent(AccountPreference.self, forKey: .preference)
        profileMetadata = try values.decodeIfPresent(Dictionary<String, String>.self, forKey: .profileMetadata)
        isBot = try values.decodeIfPresent(Bool.self, forKey: .isBot)
    }
}
