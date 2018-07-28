//
// Created by mopopo on 2018/07/29.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension FollowRequestsService {
    private static let provider = MoyaProvider<FollowRequestsService>()

    static func request(service: FollowRequestsService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
