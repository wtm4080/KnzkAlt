//
// Created by mopopo on 2018/04/05.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct AccountFollowService: TargetType {
    let baseURL: URL

    let id: String

    var path: String { return "/api/v1/accounts/\(id)/follow" }
    let method: Method = .post
    let task: Task = .requestPlain
    let sampleData = "".data(using: .utf8)!
    let headers: [String: String]? = nil
}
