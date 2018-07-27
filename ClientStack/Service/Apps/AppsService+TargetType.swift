//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

extension AppsService: TargetType {
    var baseURL: URL {
        switch self {
            case
                    .registerClient(let param, _),
                    .accessToken(let param, _, _, _):
                return param.host.url!
        }
    }

    var path: String {
        switch self {
            case .registerClient:
                return "/api/v1/apps"
            case .accessToken:
                return "/oauth/token"
        }
    }

    var method: Moya.Method {
        switch self {
            case .registerClient, .accessToken:
                return .post
        }
    }

    var task: Task {
        switch self {
            case .registerClient(_, let form):
                return .requestParameters(parameters: form.toParams(), encoding: URLEncoding.httpBody)
            case .accessToken(_, let clientRegisterResult, let userName, let password):
                return .requestParameters(
                        parameters: clientRegisterResult.toAccessTokenParams(
                                userName: userName,
                                password: password
                        ),
                        encoding: URLEncoding.httpBody
                )
        }
    }

    var headers: [String: String]? {
        switch self {
            case
                    .registerClient(let param, _),
                    .accessToken(let param, _, _, _):
                var hs = param.headers

                return hs.addContentType(contentType: .formURLEncoded)
        }
    }

    var sampleData: Data {
        return Data()
    }
}
