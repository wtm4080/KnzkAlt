//
//  Login.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/11/09.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import Foundation
import Hydra
import Result

enum LoginError: Error {
    case InvalidLoginURL
    case InvalidLoginRequestJSON
    case InvalidLoginResponse
    case NetworkError(error: Error)
}

struct LoginResult {
    let domain: String
    let clientId: String
    let clientSecret: String

    init?(data: [String: String]) {
        domain = Login.host

        guard let cid = data["client_id"] else {
            return nil
        }
        clientId = cid

        guard let scr = data["client_secret"] else {
            return nil
        }
        clientSecret = scr
    }

    func authURL() -> URL? {
        return URL(string: "https://\(Login.host)/oauth/authorize?response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=read+write+follow&client_id=\(clientId)")
    }
}

struct Login {
    static let host = "knzk.me"

    static func login() -> Promise<Result<LoginResult, LoginError>> {
        guard let appsURL = URL(string: "https://\(host)/api/v1/apps") else {
            return Promise<Result<LoginResult, LoginError>>(resolved: .failure(.InvalidLoginURL))
        }

        var appsRequest = URLRequest(url: appsURL)
        appsRequest.httpMethod = "POST"
        appsRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let appsRequestBody = [
            "scopes": "read write follow",
            "client_name": "KnzkAlt for iOS",
            "redirect_uris": "urn:ietf:wg:oauth:2.0:oob",
            "website": "https://knzkdev.net/knzkapp/"
        ]
        guard let appsRequestData = try? JSONSerialization.data(withJSONObject: appsRequestBody) else {
            return Promise<Result<LoginResult, LoginError>>(resolved: .failure(.InvalidLoginRequestJSON))
        }
        appsRequest.httpBody = appsRequestData

        return Promise<Result<LoginResult, LoginError>>(in: .background) {
            resolve, _, _ in

            URLSession.shared.dataTask(with: appsRequest) {
                data, response, error in

                if let error = error {
                    resolve(.failure(.NetworkError(error: error)))
                }
                else if let data = data, let response = response as? HTTPURLResponse {
                    guard response.statusCode == 200 else {
                        resolve(.failure(.InvalidLoginResponse))
                        return
                    }

                    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
                        resolve(.failure(.InvalidLoginResponse))
                        return
                    }

                    guard let data = json else {
                        resolve(.failure(.InvalidLoginResponse))
                        return
                    }

                    guard let result = LoginResult(data: data) else {
                        resolve(.failure(.InvalidLoginResponse))
                        return
                    }

                    resolve(.success(result))
                }
                else {
                    resolve(.failure(.InvalidLoginResponse))
                }
            }.resume()
        }
    }
}
