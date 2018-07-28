//
// Created by mopopo on 2018/07/28.
// Copyright (c) 2018 AtCurio. All rights reserved.
//

import Moya
import RxSwift
import Result

extension DomainBlocksService {
    private static let provider = MoyaProvider<DomainBlocksService>()

    static func request(service: DomainBlocksService) -> Single<Response> {
        return provider.rx.request(service)
    }
}
