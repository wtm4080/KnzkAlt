//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension BlocksService: TargetType {
    var baseURL: URL {
        switch self {
            case .blocks(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        switch self {
            case .blocks:
                return "/api/v1/blocks"
        }
    }

    var method: Moya.Method {
        switch self {
            case .blocks:
                return .get
        }
    }
    
    var task: Task {
        switch self {
            case .blocks(_, let query):
                return .requestParameters(parameters: query.toParameters(), encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
            case .blocks(let param, _):
                return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
