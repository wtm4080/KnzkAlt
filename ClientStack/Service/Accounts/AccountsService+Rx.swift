//
// Created by mopopo on 2018/07/23.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension AccountsService {
    private static let provider = MoyaProvider<AccountsService>()

    static func request(service: AccountsService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
