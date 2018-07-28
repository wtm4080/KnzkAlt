//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension BlocksService {
    private static let provider = MoyaProvider<BlocksService>()

    static func request(service: BlocksService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
