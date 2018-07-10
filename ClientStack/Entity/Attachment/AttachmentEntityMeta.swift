//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

/// Toot attachment metadata
struct AttachmentEntityMeta {
    /// Referring preview image file
    let smallImageURL: URL?

    /// Referring original image file
    let originalImageURL: URL?

    /// Image/Video(including GIFV) width
    let width: UInt?

    /// Image/Video(including GIFV) height
    let height: UInt?

    /// Image size
    let imageSize: UInt?

    /// Image aspect ratio
    let imageAspectRatio: Double?

    /// Video(including GIFV) frame rate
    let videoFrameRate: UInt?

    /// Video(including GIFV) duration
    let videoDuration: Double?

    /// Video(including GIFV) bitrate
    let videoBitrate: UInt?

    /// Focus coordinates for smart thumbnail cropping
    /// https://github.com/jonom/jquery-focuspoint#1-calculate-your-images-focus-point
    let thumbnailFocus: AttachmentEntityFocus?
}
