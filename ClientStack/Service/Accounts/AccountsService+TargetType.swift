//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension AccountsService: TargetType {
    var baseURL: URL {
        switch self {
            case
                    .account(let param, _),
                    .currentUser(let param),
                    .updateCurrentUser(let param, _),
                    .followers(let param, _, _),
                    .following(let param, _, _),
                    .statuses(let param, _, _):
                return param.host.url!
        }
    }

    var path: String {
        let basePath = "/api/v1/accounts/"

        let pathWithID = {
            (id: String, relativePath: String) -> String in

            if relativePath.isEmpty {
                return basePath + id
            } else {
                return basePath + "\(id)/\(relativePath)"
            }
        }

        switch self {
            case .account(_, let id):
                return pathWithID(id, "")
            case .currentUser:
                return basePath + "verify_credentials"
            case .updateCurrentUser:
                return basePath + "update_credentials"
            case .followers(_, let id, _):
                return pathWithID(id, "followers")
            case .following(_, let id, _):
                return pathWithID(id, "following")
            case .statuses(_, let id, _):
                return pathWithID(id, "statuses")
        }
    }

    var method: Moya.Method {
        switch self {
            case .account, .currentUser, .followers, .following, .statuses:
                return .get
            case .updateCurrentUser:
                return .patch
        }
    }

    var task: Moya.Task {
        let urlParamsTask = {
            (params: [String: Any]) -> Moya.Task in

            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }

        switch self {
            case .account, .currentUser:
                return .requestPlain
            case .updateCurrentUser(_, let form):
                return .uploadMultipart(form.toFormData())
            case
                    .followers(_, _, let query),
                    .following(_, _, let query):
                return urlParamsTask(query.toParameters())
            case .statuses(_, _, let query):
                return urlParamsTask(query.toParameters())
        }
    }

    var headers: [String: String]? {
        switch self {
            case
                    .account(let param, _),
                    .currentUser(let param),
                    .followers(let param, _, _),
                    .following(let param, _, _),
                    .statuses(let param, _, _):
                return param.headers
            case .updateCurrentUser(let param, _):
                var headers = param.headers
                headers["Content-Type"] = "multipart/form-data"

                return headers
        }
    }

    var sampleData: Data {
        return Data()
    }
}
