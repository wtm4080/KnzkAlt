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
                    .statuses(let param, _, _),
                    .follow(let param, _, _),
                    .unfollow(let param, _),
                    .block(let param, _),
                    .unblock(let param, _),
                    .mute(let param, _, _),
                    .unmute(let param, _),
                    .relationships(let param, _):
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
            case .follow(_, let id, _):
                return pathWithID(id, "follow")
            case .unfollow(_, let id):
                return pathWithID(id, "unfollow")
            case .block(_, let id):
                return pathWithID(id, "block")
            case .unblock(_, let id):
                return pathWithID(id, "unblock")
            case .mute(_, let id, _):
                return pathWithID(id, "mute")
            case .unmute(_, let id):
                return pathWithID(id, "unmute")
            case .relationships:
                return basePath + "relationships"
        }
    }

    var method: Moya.Method {
        switch self {
            case .account, .currentUser, .followers, .following, .statuses, .relationships:
                return .get
            case .updateCurrentUser:
                return .patch
            case .follow, .unfollow, .block, .unblock, .mute, .unmute:
                return .post
        }
    }

    var task: Moya.Task {
        let urlParamsTask = {
            (params: [String: Any]) -> Moya.Task in

            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }

        let bodyParamsTask = {
            (params: [String: Any?]) -> Moya.Task in

            var ps = [String: Any]()

            for (k, v) in params {
                if let v = v {
                    ps[k] = v
                }
            }

            return .requestParameters(parameters: ps, encoding: URLEncoding.httpBody)
        }

        switch self {
            case .account, .currentUser, .unfollow, .block, .unblock, .unmute:
                return .requestPlain
            case .updateCurrentUser(_, let form):
                return .uploadMultipart(form.toFormData())
            case
                    .followers(_, _, let query),
                    .following(_, _, let query):
                return urlParamsTask(query.toParameters())
            case .statuses(_, _, let query):
                return urlParamsTask(query.toParameters())
            case .follow(_, _, let isIncludeReblogs):
                return bodyParamsTask(["reblogs": isIncludeReblogs])
            case .mute(_, _, let isMutingNotifications):
                return bodyParamsTask(["notifications": isMutingNotifications])
            case .relationships(_, let ids):
                var params = [String: Any]()

                for item in ids.filter({ !$0.isEmpty }).enumerated() {
                    params["id[\(item.offset)]"] = item.element
                }

                return urlParamsTask(params)
        }
    }

    var headers: [String: String]? {
        let combine = {
            (p: ServiceParam, other: [String: String]) -> [String: String] in

            return p.headers.merging(other, uniquingKeysWith: { k1, k2 in fatalError() })
        }

        switch self {
            case
                    .account(let param, _),
                    .currentUser(let param),
                    .followers(let param, _, _),
                    .following(let param, _, _),
                    .statuses(let param, _, _),
                    .unfollow(let param, _),
                    .block(let param, _),
                    .unblock(let param, _),
                    .unmute(let param, _),
                    .relationships(let param, _):
                return param.headers
            case .updateCurrentUser(let param, _):
                return combine(param, ["Content-Type": "multipart/form-data"])
            case .follow(let param, _, _), .mute(let param, _, _):
                return combine(param, ["Content-Type": "application/x-www-form-urlencoded"])
        }
    }

    var sampleData: Data {
        return Data()
    }
}
