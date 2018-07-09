//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct AttachmentEntity: Decodable {
    let id: String
    let type: AttachmentEntityType
    let url: URL?
    let remoteURL: URL?
    let previewURL: URL
    let textURL: String?
    let meta: [AttachmentEntityMeta]?
}

enum AttachmentEntityType: String, Decodable {
    case image
    case video
    // When the type is "unknown", it is likely only remote_url is available and local url is missing
    case unknown
}

enum AttachmentEntityMeta: Decodable {
    init(from decoder: Decoder) throws {
        fatalError("Not implemented yet.")
    }
    
    case small(URL)
    case original(URL)
    case width(UInt)
    case height(UInt)
    case size(UInt)
    case aspect(Float)
    case frameRate(UInt)
    case duration(Float)
    case bitRate(UInt)
    case focus(AttachmentEntityFocus)
}

struct AttachmentEntityFocus: Decodable {
    let x: Float // [-1.0, 1.0]
    let y: Float // [-1.0, 1.0]
}
