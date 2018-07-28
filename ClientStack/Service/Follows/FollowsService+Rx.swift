//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension FollowsService {
    private static let provider = MoyaProvider<FollowsService>()

    static func request(service: FollowsService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
