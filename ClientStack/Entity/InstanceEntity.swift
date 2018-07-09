//
// Created by mopopo on 2018/04/03.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct InstanceEntity: Codable {
    let uri: URL
    let title: String
    let description: String
    let email: String
    let version: String
    let urls: [URL] // streaming API
    let languages: [String]
    let contactAccount: AccountCompoundEntity
}
