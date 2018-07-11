//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension RelationshipEntity: Decodable {
    private enum CodingKeys: String, CodingKey {
        case targetAccountID = "id"
        case isFollowing = "following"
        case isFollowedBy = "followed_by"
        case isBlocking = "blocking"
        case isMuting = "muting"
        case isMutingNotifications = "muting_notifications"
        case isFollowRequested = "requested"
        case isDomainBlocking = "domain_blocking"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        targetAccountID = try values.decode(String.self, forKey: .targetAccountID)
        isFollowing = try values.decode(Bool.self, forKey: .isFollowing)
        isFollowedBy = try values.decode(Bool.self, forKey: .isFollowedBy)
        isBlocking = try values.decode(Bool.self, forKey: .isBlocking)
        isMuting = try values.decode(Bool.self, forKey: .isMuting)
        isMutingNotifications = try values.decode(Bool.self, forKey: .isMutingNotifications)
        isFollowRequested = try values.decode(Bool.self, forKey: .isFollowRequested)
        isDomainBlocking = try values.decode(Bool.self, forKey: .isDomainBlocking)
    }
}
