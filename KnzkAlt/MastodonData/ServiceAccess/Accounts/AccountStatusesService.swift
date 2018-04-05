//
// Created by mopopo on 2018/04/05.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct AccountStatusesService: TargetType {
    let baseURL: URL

    let id: String
    let onlyMedia: Bool?
    let pinned: Bool?
    let excludeReplies: Bool?
    let maxId: String?
    let sinceId: String?
    let limit: UInt?

    var path: String { return "/api/v1/accounts/\(id)/statuses" }
    let method: Method = .get
    let task: Task = .requestPlain
    let sampleData = "".data(using: .utf8)!
    let headers: [String: String]? = nil
}
