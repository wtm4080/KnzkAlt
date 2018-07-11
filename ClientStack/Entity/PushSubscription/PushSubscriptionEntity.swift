//
// Created by mopopo on 2018/07/11.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Push subscription entity
struct PushSubscriptionEntity {
    /// The push subscription ID
    let id: String

    /// The endpoint URL
    let endpointURL: URL

    /// The server public key for signature verification. (not for decoding)
    let serverKey: String

    /// Map of `notification event type` and `push is requested or not`
    let alerts: [String: String]?
}
