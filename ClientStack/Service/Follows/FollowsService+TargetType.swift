//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension FollowsService: TargetType {
    var baseURL: URL {
        switch self {
            case .followRemote(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        switch self {
            case .followRemote:
                return "/api/v1/follows"
        }
    }

    var method: Moya.Method {
        switch self {
            case .followRemote:
                return .post
        }
    }

    var task: Task {
        switch self {
            case .followRemote(_, let remoteUserURI):
                return .requestParameters(parameters: ["uri": remoteUserURI], encoding: URLEncoding.httpBody)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .followRemote(let param, _):
            return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
