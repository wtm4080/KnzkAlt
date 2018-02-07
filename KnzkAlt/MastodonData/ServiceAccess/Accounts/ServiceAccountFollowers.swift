//
// Created by mopopo on 2018/02/08.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct ServiceAccountFollowers: TargetType {
    let baseURL: URL

    let id: String
    let max_id: Int?
    let since_id: Int?
    let limit: Int?

    var path: String { return "/api/v1/accounts/\(id)/followers" }
    let method: Method = .get
    let task: Task = .requestPlain
    let sampleData = "".data(using: .utf8)!
    let headers: [String: String]? = nil
}
