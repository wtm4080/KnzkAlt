//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension AppsService {
    private static let provider = MoyaProvider<AppsService>()

    static func request(service: AppsService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
