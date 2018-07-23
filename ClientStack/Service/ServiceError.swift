//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya

enum ServiceError: Error {
    case network(e: Error)
    case response(response: Response)
    case parseResponse(e: Error)
}
