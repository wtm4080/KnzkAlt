//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension DomainBlocksService: TargetType {
    var baseURL: URL {
        switch self {
            case
                    .domainBlocks(let param, _),
                    .block(let param, _),
                    .unblock(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        switch self {
            case .domainBlocks, .block, .unblock:
                return "/api/v1/domain_blocks"
        }
    }

    var method: Moya.Method {
        switch self {
            case .domainBlocks:
                return .get
            case .block:
                return .post
            case .unblock:
                return .delete
        }
    }

    var task: Task {
        switch self {
            case .domainBlocks(_, let query):
                return .requestParameters(parameters: query.toParameters(), encoding: URLEncoding.queryString)
            case
                    .block(_, let domain),
                    .unblock(_, let domain):
                return .requestParameters(parameters: ["domain": domain], encoding: URLEncoding.httpBody)
        }
    }

    var headers: [String: String]? {
        switch self {
            case
                    .domainBlocks(let param, _),
                    .block(let param, _),
                    .unblock(let param, _):
                return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
