//
// Created by mopopo on 2018/02/08.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct ServiceAccount: TargetType {
    let baseURL: URL
    let id: String

    var path: String { return "/api/v1/accounts/\(id)" }
    let method: Moya.Method = .get
    let task: Task = .requestPlain
    let sampleData = "".data(using: .utf8)!
    let headers: [String: String]? = nil
}
