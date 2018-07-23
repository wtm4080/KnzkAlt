//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension AccountsService: TargetType {
    var baseURL: URL {
        switch self {
            case .account(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        let basePath = "/api/v1/accounts/"

        switch self {
            case .account(_, let id):
                return basePath + id
        }
    }

    var method: Moya.Method {
        switch self {
            case .account:
                return .get
        }
    }

    var task: Moya.Task {
        switch self {
            case .account:
                return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
            case .account(let param, _):
                return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
