//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension FollowRequestsService: TargetType {
    var baseURL: URL {
        switch self {
            case
                    .followRequests(let param, _),
                    .authorise(let param, _),
                    .reject(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        let basePath = "/api/v1/follow_requests"
        let basePathWithIDAction = {
            (accountID: String, action: String) -> String in

            return basePath + "/\(accountID)/\(action)"
        }

        switch self {
            case .followRequests:
                return basePath
            case .authorise(_, let accountID):
                return basePathWithIDAction(accountID, "authorize")
            case .reject(_, let accountID):
                return basePathWithIDAction(accountID, "reject")
        }
    }

    var method: Moya.Method {
        switch self {
            case .followRequests:
                return .get
            case .authorise, .reject:
                return .post
        }
    }

    var task: Task {
        switch self {
            case .followRequests(_, let query):
                return .requestParameters(parameters: query.toParameters(), encoding: URLEncoding.queryString)
            case .authorise, .reject:
                return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case
                .followRequests(let param, _),
                .authorise(let param, _),
                .reject(let param, _):
            return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
