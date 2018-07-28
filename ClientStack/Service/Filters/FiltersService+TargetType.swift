//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension FiltersService: TargetType {
    var baseURL: URL {
        switch self {
            case
                    .filters(let param),
                    .filter(let param, _),
                    .create(let param, _),
                    .update(let param, _, _),
                    .delete(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        let basePath = "/api/v1/filters"

        switch self {
            case .filters, .create:
                return basePath
            case
                    .filter(_, let id),
                    .update(_, let id, _),
                    .delete(_, let id):
                return basePath + "/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
            case .filters, .filter:
                return .get
            case .create:
                return .post
            case .update:
                return .put
            case .delete:
                return .delete
        }
    }

    var task: Task {
        switch self {
            case .filters, .filter, .delete:
                return .requestPlain
            case
                    .create(_, let form),
                    .update(_, _, let form):
                return .requestParameters(parameters: form.toParameters(), encoding: URLEncoding.httpBody)
        }
    }

    var headers: [String: String]? {
        switch self {
            case
                    .filters(let param),
                    .filter(let param, _),
                    .create(let param, _),
                    .update(let param, _, _),
                    .delete(let param, _):
                return param.headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
