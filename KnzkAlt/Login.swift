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

struct LoginAuthResult {
    let token: String

    init?(data: [String: String]) {
        guard let tk = data["access_token"] else {
            return nil
        }
        token = tk
    }
}

enum LoginAuthError: Error {
    case InvalidParamURL
    case InvalidTokenURL
    case InvalidTokenRequestJSON
    case NetworkError(error: Error)
    case InvalidLoginResponse
}

struct LoginAuth {
    static func auth(url: URL, loginResult: LoginResult) -> Promise<Result<LoginAuthResult, LoginAuthError>> {
        let absURL = url.absoluteString

        if absURL.contains("/oauth/authorize/") {
            let regExpPattern = "[^/]+$"
            let regExp = try? NSRegularExpression(pattern: regExpPattern)
            guard let regExpMatches = regExp?.matches(
                    in: absURL,
                    options: [],
                    range: NSRange(location: 0, length: absURL.count)) else {
                return Promise<Result<LoginAuthResult, LoginAuthError>>(resolved: .failure(.InvalidParamURL))
            }

            guard let match = regExpMatches.first, match.numberOfRanges == 1 else {
                return Promise<Result<LoginAuthResult, LoginAuthError>>(resolved: .failure(.InvalidParamURL))
            }

            let range = match.range(atIndex: 0)
            let code = absURL.substring(with: range)

            guard let tokenURL = URL(string: "https://\(Login.host)/oauth/token") else {
                return Promise<Result<LoginAuthResult, LoginAuthError>>(resolved: .failure(.InvalidTokenURL))
            }

            var tokenRequest = URLRequest(url: tokenURL)
            tokenRequest.httpMethod = "POST"
            tokenRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let tokenRequestBody = [
                "scope": "read write follow",
                "client_id": loginResult.clientId,
                "client_secret": loginResult.clientSecret,
                "grant_type": "authorization_code",
                "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                "code": code
            ]
            guard let tokenRequestData = try? JSONSerialization.data(withJSONObject: tokenRequestBody) else {
                return Promise<Result<LoginAuthResult, LoginAuthError>>(resolved: .failure(.InvalidTokenRequestJSON))
            }
            tokenRequest.httpBody = tokenRequestData

            return Promise<Result<LoginAuthResult, LoginAuthError>>(in: .background) {
                resolve, _, _ in

                URLSession.shared.dataTask(with: tokenRequest) {
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

                        guard let result = LoginAuthResult(data: data) else {
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
        else {
            return Promise<Result<LoginAuthResult, LoginAuthError>>(resolved: .failure(.InvalidParamURL))
        }
    }
}

struct VerifyCredResult {
    let userName: String
    let userId: String

    init?(data: [String: String]) {
        guard let acct = data["acct"] else {
            return nil
        }
        userName = acct

        guard let id = data["id"] else {
            return nil
        }
        userId = id
    }
}

enum VerifyCredError: Error {
    case InvalidVerifyURL
    case NetworkError(error: Error)
    case InvalidLoginResponse
}

struct LoginVerifyCred {
    func verify(authResult: LoginAuthResult) -> Promise<Result<VerifyCredResult, VerifyCredError>> {
        guard let url = URL(string: "https://\(Login.host)/api/v1/accounts/verify_credentials") else {
            return Promise<Result<VerifyCredResult, VerifyCredError>>(resolved: .failure(.InvalidVerifyURL))
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(authResult.token)", forHTTPHeaderField: "Authorization")

        return Promise<Result<VerifyCredResult, VerifyCredError>>(in: .background) {
            resolve, _, _ in

            URLSession.shared.dataTask(with: request) {
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

                    guard let result = VerifyCredResult(data: data) else {
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