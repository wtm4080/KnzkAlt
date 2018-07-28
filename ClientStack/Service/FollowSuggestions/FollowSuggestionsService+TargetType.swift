//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension FollowSuggestionsService: TargetType {
    var baseURL: URL {
        switch self {
            case
                    .suggestions(let param),
                    .delete(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        let basePath = "/api/v1/suggestions"

        switch self {
            case .suggestions:
                return basePath
            case .delete(_, let accountID):
                return basePath + "/\(accountID)"
        }
    }

    var method: Moya.Method {
        switch self {
            case .suggestions:
                return .get
            case .delete:
                return .delete
        }
    }

    var task: Task {
        switch self {
            case .suggestions, .delete:
                return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case
                .suggestions(let param),
                .delete(let param, _):
            return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
