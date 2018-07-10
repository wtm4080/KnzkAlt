//
// Created by mopopo on 2018/07/10.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

extension AttachmentEntityMeta: Decodable {
    private enum CodingKeys: String, CodingKey {
        case smallImageURL = "small"
        case originalImageURL = "original"
        case width = "width"
        case height = "height"
        case imageSize = "size"
        case imageAspectRatio = "aspect"
        case videoFrameRate = "frame_rate"
        case videoDuration = "duration"
        case videoBitrate = "bitrate"
        case thumbnailFocus = "focus"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        smallImageURL = try values.decodeIfPresent(URL.self, forKey: .smallImageURL)
        originalImageURL = try values.decodeIfPresent(URL.self, forKey: .originalImageURL)
        width = try values.decodeIfPresent(UInt.self, forKey: .width)
        height = try values.decodeIfPresent(UInt.self, forKey: .height)
        imageSize = try values.decodeIfPresent(UInt.self, forKey: .imageSize)
        imageAspectRatio = try values.decodeIfPresent(Double.self, forKey: .imageAspectRatio)
        videoFrameRate = try values.decodeIfPresent(UInt.self, forKey: .videoFrameRate)
        videoDuration = try values.decodeIfPresent(Double.self, forKey: .videoDuration)
        videoBitrate = try values.decodeIfPresent(UInt.self, forKey: .videoBitrate)
        thumbnailFocus = try values.decodeIfPresent(AttachmentEntityFocus.self, forKey: .thumbnailFocus)
    }
}
