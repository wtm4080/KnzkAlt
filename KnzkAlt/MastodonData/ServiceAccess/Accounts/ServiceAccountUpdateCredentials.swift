//
// Created by mopopo on 2018/02/08.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

struct ServiceAccountUpdateCredentials: TargetType {
    let baseURL: URL

    let displayName: String?
    let note: String?
    let avatar: Data?
    let header: Data?

    let path = "/api/v1/accounts/update_credentials"
    let method: Method = .patch
    let task: Task = .uploadMultipart([])
    let sampleData: Data = "".data(using: .utf8)!
    let headers: [String: String]? = nil
}
