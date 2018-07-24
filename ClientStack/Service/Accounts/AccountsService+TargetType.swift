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
                    .updateCurrentUser(let param, _):
                return param.host.url!
        }
    }

    var path: String {
        let basePath = "/api/v1/accounts/"

        switch self {
            case .account(_, let id):
                return basePath + id
            case .currentUser:
                return basePath + "verify_credentials"
            case .updateCurrentUser:
                return basePath + "update_credentials"
        }
    }

    var method: Moya.Method {
        switch self {
            case .account, .currentUser:
                return .get
            case .updateCurrentUser:
                return .patch
        }
    }

    var task: Moya.Task {
        switch self {
            case .account, .currentUser:
                return .requestPlain
            case .updateCurrentUser(_, let form):
                return .uploadMultipart(form.toFormData())
        }
    }

    var headers: [String: String]? {
        switch self {
            case .account(let param, _), .currentUser(let param):
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
