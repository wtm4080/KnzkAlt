//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Foundation

enum AppsService {
    /// Creates a new OAuth app.
    /// Returns `id`, `client_id`, `client_secret` which can be used with [OAuth authentication in your 3rd party app](https://github.com/tootsuite/documentation/blob/master/Using-the-API/Testing-with-cURL.md)
    /// These values should be requested in the app itself from the API for each new app install + mastodon domain combo,
    /// and stored in the app for future requests.
    case registerClient(param: ServiceParam, form: AppsRegisterForm)

    /// After registering the client, requesting an access token.
    /// Returning a JSON object containing the key `access_token` if the login succeeded.
    case accessToken(param: ServiceParam, registerClientResult: AppsRegisterResult, userName: String, password: String)
}
