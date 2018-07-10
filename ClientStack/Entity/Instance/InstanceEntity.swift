//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Mastodon instance entity
struct InstanceEntity {
    /// URI of the current instance
    let uri: URL

    /// The instance's title
    let title: String

    /// A description for the instance
    let description: String

    /// An email address which can be used to contact the instance administrator
    let email: String

    /// The Mastodon version used by instance.
    let version: String

    /// Streaming API URLs
    let streamingAPIURLs: [URL]

    /// Array of ISO 6391 language codes the instance has chosen to advertise
    let languageCodes: [String]

    /// Account of the administrator or another contact person
    let contactAccount: AccountEntityCompound
}
