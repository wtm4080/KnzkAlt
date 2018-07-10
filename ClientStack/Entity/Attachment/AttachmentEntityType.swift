//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Type of toot attachment
enum AttachmentEntityType: String, Decodable {
    case image
    case video
    // When the type is "unknown", it is likely only remote_url is available and local url is missing
    case unknown
}
