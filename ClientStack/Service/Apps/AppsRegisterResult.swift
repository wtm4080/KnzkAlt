//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

struct AppsRegisterResult: Decodable {
    /// An ID of the client registration record
    let id: String

    /// OAuth2 client ID
    let clientID: String

    /// OAuth2 client secret
    let clientSecret: String

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case clientSecret = "client_secret"
    }

    func toAccessTokenParams(userName: String, password: String) -> [String: Any] {
        return [
            "client_id": clientID,
            "client_secret": clientSecret,
            "grant_type": "password",
            "username": userName,
            "password": password
        ]
    }
}
