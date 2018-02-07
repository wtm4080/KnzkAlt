//
// Created by mopopo on 2018/02/08.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct ServiceAccountVerifyCredentials: TargetType {
    let baseURL: URL

    let path = "/api/v1/accounts/verify_credentials"
    let method: Method = .get
    let task: Task = .requestPlain
    let sampleData = "".data(using: .utf8)!
    let headers: [String: String]? = nil
}
