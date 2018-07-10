//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Toot attachment entity
struct AttachmentEntity {
    /// ID of the attachment
    let id: String

    /// One of `image`, `video`, `gifv`, `unknown`
    let type: AttachmentEntityType

    /// URL of the locally hosted version of the image
    /// When the type is `unknown`, it is likely only remote URL is available and local URL is missing
    let localImageURL: URL?

    /// For remote images, the remote URL of the original image
    let remoteImageURL: URL?

    /// URL of the preview image
    let previewImageURL: URL?

    /// Shorter URL for the image, for insertion into text (only present on local images)
    let urlText: String?

    /// May contain some metadata for the attachment
    let metadata: AttachmentEntityMeta?

    /// A description of the image for the visually impaired (maximum 420 characters),
    /// or null if none provided
    let description: String?
}
